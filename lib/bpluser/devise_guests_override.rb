# frozen_string_literal: true

module Bpluser
  module DeviseGuestsOverride
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
    end

    module InstanceMethods
      private

      def guest_uid_authentication_key(key)
        key &&= nil unless key.to_s.match?(/^guest/)
        key || "guest_#{guest_user_unique_suffix}@example.com"
      end
    end
  end
end
