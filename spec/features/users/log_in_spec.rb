# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logging in User', js: true do
  skip 'Successful Sign In' do
    let!(:test_user) { create(:user) }

    before do
      visit root_path
      click_on 'Sign Up / Log In'
    end
  end
end
