# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:polaris] = OmniAuth::AuthHash.new({
    provider: 'polaris',
    uid: '299999999999',
    info: {
      barcode: '299999999999',
      valid_patron: 'true',
      assigned_branch_id: '1',
      assigned_branch_name: 'My Awesome Library - Central',
      first_name: 'Test',
      last_name: 'Testerson',
      middle_name: 'T',
      phone_number: '555-555-5555',
      email: 'test.testerson@example.com'
    },
    extra: {
      raw_info: {
        'Barcode' => '299999999999',
        'ValidPatron' => 'true',
        'PatronID' => '111111111',
        'PatronCodeID' => '1',
        'AssignedBranchID' => '1',
        'AssignedBracnhName' => 'My Awesome Library - Central',
        'PatronBarcode' => '299999999999',
        'ExpirationDate' => '2026-02-19T00:00:00',
        'NameFirst' => 'Test',
        'NameLast' => 'Testerson',
        'NameMiddle' => 'T',
        'PhoneNumber' => '555-555-5555',
        'EmailAddress' => 'test.testerson@example.com'
      }
    }
  })

  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end
