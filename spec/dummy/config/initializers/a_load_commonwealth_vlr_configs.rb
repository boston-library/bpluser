# frozen_string_literal: true

# various app-specific config settings
# use file name "a_load_commonwealth_vlr_configs" so Rails loads this file before other initializers

ASSET_STORE = Rails.application.config_for('asset_store')

OMNIAUTH_POLARIS_GLOBAL = Rails.application.config_for('omniauth-polaris')
