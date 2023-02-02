# frozen_string_literal: true

module Bpluser
  module Validatable
    extend ActiveSupport::Concern

    included do
      include InstanceMethods

      validates :uid, presence: true, uniqueness: { scope: :provider, allow_blank: true }, if: :uid_required?
    end

    # Overrides devise mthods used for validations
    module InstanceMethods
      protected

      def uid_required?
        provider == 'polaris'
      end

      def email_required?
        return false if provider == 'polaris'

        super
      end

      def password_required?
        return false if provider == 'polaris'

        super
      end
    end
  end
end
