# frozen_string_literal: true

module Bpluser
  module Validatable
    extend ActiveSupport::Concern

    VALIDATIONS = %i[validates_presence_of validates_format_of validates_confirmation_of validates_length_of].freeze
    # BEGIN INCLUDED
    included do
      include InstanceMethods
      validates :email, presence: true, if: [:email_required?, :email_not_required?]
      validates :email, format: { with: email_regexp, allow_blank: true }, if: [:email_changed?, :email_not_required?]

      validates :password, presence: true, confirmation: true, if: :password_required?
      validates :password, length: { within: password_length, allow_blank: true }
    end
    # END INCLUDED

    # INSTANCE METHODS
    module InstanceMethods
      protected

      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end

      def email_required?
        true
      end
    end

    # BEGIN CLASS METHODS
    class_methods do
      ::Devise::Models.config(self, :email_regexp, :password_length)

      def required_fields(_klass)
        []
      end
    end
    # END CLASS METHODS
  end
end
