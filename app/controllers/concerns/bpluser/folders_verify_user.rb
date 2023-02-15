# frozen_string_literal: true

module Bpluser
  module FoldersVerifyUser
    # Concern that adds verify_user method for folder related controller endopints t('blacklight.folders.need_login')
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
    end

    module InstanceMethods
      protected

      def verify_user
        flash[:notice] = t('blacklight.folders.need_login') and raise Blacklight::Exceptions::AccessDenied unless current_user
      end
    end
  end
end
