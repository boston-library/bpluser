module Bpluser::User


  def self.included(base)
    base.send :devise, :database_authenticatable, :registerable,
              :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:ldap, :polaris, :facebook, :password]
    base.send :attr_accessible, :provider, :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :display_name
    base.send :has_many, :user_institutions, :class_name => "Bpluser::UserInstitution"
    base.send :has_many, :folders, :dependent => :destroy, :class_name => "Bpluser::Folder"
    base.extend(ClassMethods)
    base.send :include, InstanceMethods

  end

  module ClassMethods
    def find_for_ldap_oauth(auth_response, signed_in_resource=nil)

      ldap_raw_details = auth_response[:extra][:raw_info]
      ldap_info_details = auth_response[:info]

      user = User.where(:provider => auth_response.provider, :username => ldap_raw_details.samaccountname[0].downcase).first

      #first_name:ldap_info_details.first_name,
      #last_name:ldap_info_details.last_name,
      unless user
        user = User.create(provider:auth_response.provider,
                           username:ldap_raw_details.samaccountname[0].downcase,
                           email:ldap_raw_details.mail[0].to_s.downcase,
                           password:Devise.friendly_token[0,20],
                           display_name: ldap_info_details.first_name[0] + " " + ldap_info_details.last_name[0],
                           first_name: ldap_info_details.first_name[0],
                           last_name: ldap_info_details.last_name[0]
        )
      end
      groups = user.ldap_groups
      groups.each do |group|
        if(group == "Repository Administrators")
          admin_role = Role.where(:name=>'admin')
          if(admin_role.length == 0)
            Role.create(:name=>"admin")
            admin_role = Role.where(:name=>'admin')
          end
          user.roles << admin_role[0] unless user.roles.include?(admin_role[0])
          user.save!
        end

      end

      user
    end

    def find_for_polaris_oauth(auth_response, signed_in_resource=nil)
      polaris_raw_details = auth_response[:extra][:raw_info]
      polaris_info_details = auth_response[:info]

      user = User.where(:provider => auth_response.provider, :username => auth_response[:uid]).first

      #first_name:ldap_info_details.first_name,
      #last_name:ldap_info_details.last_name,
      unless user
        user = User.create(provider:auth_response.provider,
                           username:auth_response[:uid],
                           email:auth_response[:uid]+"@doesnotexist.com",
                           password:Devise.friendly_token[0,20],
                           display_name:auth_response[:uid]
        )

      end
      user
    end

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :username => auth.uid).first
      unless user
        user = User.create(display_name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           username:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
        )
      end
      user
    end

    # This method should find User objects using the user_key you've chosen.
    # By default, uses the unique identifier specified in by devise authentication_keys (ie. find_by_id, or find_by_email).
    # You must have that find method implemented on your user class, or must override find_by_user_key
    #def find_by_user_key(key)
      #self.send("find_by_#{Devise.authentication_keys.first}".to_sym, key)
    #end
  end

  #has_and_belongs_to_many :groups

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.

  # The following methods will be included in any active model object
  # that calls "is_blacklight_user"
  module InstanceMethods


    def to_s
      self.username
    end

    def name
      return self.display_name.titleize || self.username rescue self.username
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
      self.folders.find do |fldr|
        fldr.folder_items.find do |fldr_itm|
          return fldr_itm if fldr_itm.document_id == document_id
        end
      end
    end

  end
end