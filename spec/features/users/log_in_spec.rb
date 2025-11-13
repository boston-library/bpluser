# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logging in User', :js do
  before do
    visit new_user_session_path
  end

  context 'when successful sign in' do
    let!(:test_user) { create(:user) }
    let!(:test_user_password) { attributes_for(:user)[:password] }
    let!(:successful_sign_in_message) { I18n.t('devise.sessions.signed_in') }

    context 'with remember me unchecked' do
      before do
        within 'form#new_user' do
          fill_in 'Email', with: test_user.email
          fill_in 'Password', with: test_user_password
          click_on 'Sign in'
        end
        test_user.reload
      end

      it 'expects the user to have been signed in' do
        expect(page).to have_current_path(root_path)
      end

      it 'expects the page to have a sucessful sign in message' do
        expect(page).to have_content(successful_sign_in_message)
      end
    end

    context 'with remember me checked' do
      before do
        within 'form#new_user' do
          fill_in 'Email', with: test_user.email
          fill_in 'Password', with: test_user_password
          check 'Remember me on this device'
          click_on 'Sign in'
        end
      end

      it 'expects test user to have remember_created_at set' do
        test_user.reload
        expect(test_user.remember_created_at).to be_truthy.and be_a(ActiveSupport::TimeWithZone)
        expect(test_user.remember_created_at.utc.to_f).to be_within(1.minute.ago.utc.to_f).of(Time.now.utc.to_f)
      end
    end

    context 'when sign in is unsucessful' do
      before do
        within 'form#new_user' do
          fill_in 'Email', with: 'foo@bar.com'
          fill_in 'Password', with: 'foobar'
          click_on 'Sign in'
        end
      end

      it 'expects the page to still be on the sign in page' do
        expect(page).to have_current_path(new_user_session_path)
      end

      it 'expects the page to have error messages' do
        expect(page).to have_content('Invalid Email or password.')
      end
    end
  end
end
