module Bpluser
  module Models
    module Validatable
      extend ActiveSupport::Concern
      VALIDATIONS = %i(validates_presence_of validates_format_of validates_confirmation_of validates_length_of).freeze
      #BEGIN INCLUDED
      included do
        assert_validations_api!(self.class)
        validates_presence_of   :email, if: [:email_required?, :email_not_required?]
        #validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
        validates_format_of     :email, with: email_regexp, allow_blank: true, if: [:email_changed?, :email_not_required?]

        validates_presence_of     :password, if: :password_required?
        validates_confirmation_of :password, if: :password_required?
        validates_length_of       :password, within: password_length, allow_blank: true

        #INSTANCE METHODS
        protected
        def password_required?
          !persisted? || !password.nil? || !password_confirmation.nil?
        end

        def email_required?
          true
        end
      end
      #END INCLUDED

      #BEGIN CLASS METHODS
      class_methods do
        ::Devise::Models.config(self, :email_regexp, :password_length)

        def required_fields(klass)
          []
        end

        def assert_validations_api!(base) #:nodoc:
          unavailable_validations = VALIDATIONS.select { |v| !base.respond_to?(v) }

          unless unavailable_validations.empty?
            raise "Could not use :validatable module since #{base} does not respond " <<
                      "to the following methods: #{unavailable_validations.to_sentence}."
          end
        end
      end
    end
  end
end
