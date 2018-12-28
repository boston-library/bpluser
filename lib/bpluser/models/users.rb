module Bpluser
  module Models
    module Users
      #Changed this to a concern so the modules can resolve better
      extend ActiveSupport::Concern
      #included
      included do
        devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:ldap, :polaris, :facebook]

        has_many :user_institutions, inverse_of: :user, dependent: :destroy, :class_name => "Bpluser::UserInstitution"

        has_many :folders, inverse_of: :user, :dependent => :destroy, :class_name => "Bpluser::Folder"
        has_many :folder_items, through: :folders, class_name: "Bpluser::FolderItem"

        #BEGIN INSTANCE METHODS
        def to_s
          self.name
        end

        def name
          return self.username rescue self.display_name.try(:titleize)
        end

        def user_key
          send(Devise.authentication_keys.first)
        end


        def ldap_groups
          #Hydra::LDAP.groups_for_user(username + ",dc=psu,dc=edu")
          #['archivist', 'admin_policy_object_editor']

          Hydra::LDAP.groups_for_user(Net::LDAP::Filter.eq('samaccountname', self.username), ['memberOf'])  { |result| result.first[:memberOf].select{ |y| y.starts_with? 'CN=' }.map{ |x| x.sub(/^CN=/, '').sub(/,OU=Private Groups,DC=private,DC=bpl,DC=org/, '').sub(/,OU=Distribution Lists/, '').sub(/,OU=Security Groups/, '') } } rescue []
        end

        def populate_attributes
        end

        def default_user_groups
          # # everyone is automatically a member of the group 'public'
          #['public', 'test']
        end

        def get_uploads_collection
          query="rightsMetadata_edit_access_machine_person_t:#{uid} AND title_s:Uploads AND has_model_s:info\\:fedora/afmodel\\:DILCollection"
          ActiveFedora::SolrService.query(query, {:fl=>'id title_t'})
        end

        def get_details_collection
          query="rightsMetadata_edit_access_machine_person_t:#{uid} AND title_s:Details AND has_model_s:info\\:fedora/afmodel\\:DILCollection"
          ActiveFedora::SolrService.query(query, {:fl=>'id title_t'})
        end

        def collections
          query="rightsMetadata_edit_access_machine_person_t:#{uid} AND NOT title_t:Uploads AND NOT title_t:Details AND has_model_s:info\\:fedora/afmodel\\:DILCollection"
          ActiveFedora::SolrService.query(query, {:fl=>'id title_t'})
        end

        def existing_folder_item_for (document_id)
          self.get_folder_item(document_id)
        end

        def get_folder_item (document_id)
          self.folder_items.where(document_id: document_id) if self.folder_items.where(document_id: document_id).exists?
        end

        def superuser?
          roles.where(name: 'superuser').exists?
        end

        def permanent_account?
          self.provider != 'digital_stacks_temporary'
        end

        def email_not_required?
           self.provider != 'digital_stacks_temporary' and self.provider != 'polaris'
        end
        #END INSTANCE METHODS
      end




      #BEGIN CLASS METHODS
      class_methods do
        def find_for_ldap_oauth(auth_response, signed_in_resource=nil)

          ldap_raw_details = auth_response[:extra][:raw_info]
          ldap_info_details = auth_response[:info]

          user = User.where(:provider => auth_response.provider, :uid => ldap_raw_details.samaccountname[0].downcase).first

          #first_name:ldap_info_details.first_name,
          #last_name:ldap_info_details.last_name,
          unless user
            user = User.create(provider:auth_response.provider,
                               uid:ldap_raw_details.samaccountname[0].downcase,
                               username:ldap_raw_details.samaccountname[0].downcase,
                               email:ldap_raw_details.mail[0].to_s.downcase,
                               password:Devise.friendly_token[0,20],
                               display_name: ldap_info_details.first_name + " " + ldap_info_details.last_name,
                               first_name: ldap_info_details.first_name,
                               last_name: ldap_info_details.last_name
            )
          end
          groups = user.ldap_groups
          groups.each do |group|
            if(group == "Repository Administrators")
              superuser_role = Role.where(:name=>'superuser').first
              if(superuser_role == nil)
                superuser_role = Role.create(:name=>"superuser")
              end
              user.roles << superuser_role unless user.roles.include?(superuser_role)
              user.save!

              admin_role = Role.where(:name=>'admin').first
              if(admin_role == nil)
                admin_role = Role.create(:name=>"admin")
              end
              user.roles << admin_role unless user.roles.include?(admin_role)
              user.save!
            end
          end
          user
        end

        def find_for_polaris_oauth(auth_response, signed_in_resource=nil)
          polaris_raw_details = auth_response[:extra][:raw_info]
          polaris_info_details = auth_response[:info]

          user = User.where(:provider => auth_response.provider, :uid => auth_response[:uid]).first

          #first_name:ldap_info_details.first_name,
          #last_name:ldap_info_details.last_name,
          unless user
            email_value = polaris_info_details[:email].present? ? polaris_info_details[:email] : ''
            #For some reason, User.create has no id set despite that intending to be autocreated. Unsure what is up with that. So trying this.
            user = User.new(provider:auth_response.provider,
                               uid:auth_response[:uid],
                               username:polaris_info_details[:first_name],
                               email:email_value,
                               password:Devise.friendly_token[0,20],
                               display_name:polaris_info_details[:first_name] + " " + polaris_info_details[:last_name],
                               first_name: polaris_info_details[:first_name],
                               last_name: polaris_info_details[:last_name]

            )
            user.save!

          end
          user
        end

        def find_for_facebook_oauth(auth, signed_in_resource=nil)
          user = User.where(:provider => auth.provider, :uid => auth.uid).first
          unless user
            user = User.create(display_name:auth.extra.raw_info.name,
                               uid:auth.uid,
                               provider:auth.provider,
                               username:auth.info.nickname,
                               email:auth.info.email,
                               password:Devise.friendly_token[0,20] ,
                               first_name:auth.extra.raw_info.first_name,
                               last_name:auth.extra.raw_info.last_name
            )
          end
          user
        end

        def find_for_local_auth(auth, signed_in_resource=nil)
          user = User.where(:provider => auth.provider, :uid => auth.uid).first
          unless user
            user = User.create(display_name:auth.full_name,
                               uid:auth.uid,
                               provider:auth.provider,
                               username:auth.uid,
                               email:auth.email,
                               password:auth.password,
                               first_name:auth.first_name,
                               last_name:auth.last_name
            )
          end
          user
        end
      end
      #END CLASS METHODS
    end
  end
end
