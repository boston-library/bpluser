# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registering a new User', js: true do
  context 'when new User' do
    let!(:new_user_attributes) { attributes_for(:user) }
    let!(:successful_sign_up_message) { I18n.t('devise.registrations.signed_up') }

    before do
      visit root_path
      click_on 'Sign Up / Log In'
    end

    context 'when form is filled out correctly' do
      before do
        within 'div#signin_wrapper' do
          click_on 'Sign Up'
        end

        within 'form.new_user' do
          fill_in 'user_first_name', with: new_user_attributes[:first_name]
          fill_in 'user_last_name', with: new_user_attributes[:last_name]
          fill_in 'user_email', with: new_user_attributes[:email]
          fill_in 'user_password', with: new_user_attributes[:password]
          fill_in 'user_password_confirmation', with: new_user_attributes[:password_confirmation]
          click_button 'Sign up'
        end
      end

      it 'expects the page to have the successful_sign_up_message' do
        expect(page).to have_content(successful_sign_up_message)
      end

      it 'expects the page to be at the root path' do
        expect(page).to have_current_path(root_path)
      end
    end

    context 'when form is filled out incorrectly' do
      context 'when missing required fields' do
        let!(:email_error) { "Email can't be blank" }
        let!(:password_error) { "Password can't be blank" }

        before do
          within 'div#signin_wrapper' do
            click_on 'Sign Up'
          end

          within 'form.new_user' do
            fill_in 'user_first_name', with: 'Foo'
            fill_in 'user_last_name', with: 'Bar'
            click_button 'Sign up'
          end
        end

        it 'expects the page to have errors with missing attributes' do
          expect(page).to have_content(email_error)
          expect(page).to have_content(password_error)
        end

        it 'expects the page to be at the sign up path' do
          expect(page).to have_current_path(users_path) # Investigate why the path is /users instead of /users/sign_up
        end
      end

      context "when passwords don't match" do
        let!(:password_conf_error)  { "Password confirmation doesn't match Password" }

        before do
          within 'div#signin_wrapper' do
            click_on 'Sign Up'
          end

          within 'form.new_user' do
            fill_in 'user_first_name', with: new_user_attributes[:first_name]
            fill_in 'user_last_name', with: new_user_attributes[:last_name]
            fill_in 'user_email', with: new_user_attributes[:email]
            fill_in 'user_password', with: new_user_attributes[:password]
            fill_in 'user_password_confirmation', with: 'notmatchingpassword'
            click_button 'Sign up'
          end
        end

        it 'expects the page to have error about password confirmation' do
          expect(page).to have_content(password_conf_error)
        end

        it 'expects the page to be at the sign up path' do
          expect(page).to have_current_path(users_path) # Investigate why the path is /users instead of /users/sign_up
        end
      end
    end
  end

  context 'when User already exists' do
    let!(:existing_user) { create(:user) }
    let!(:expected_error_message) { "An account with that email (#{existing_user.email}) already exists. Please sign in or click the \"Forgot your password?\" link below." }

    before do
      visit root_path
      click_on 'Sign Up / Log In'

      within 'div#signin_wrapper' do
        click_on 'Sign Up'
      end

      within 'form.new_user' do
        fill_in 'user_first_name', with: existing_user.first_name
        fill_in 'user_last_name', with: existing_user.last_name
        fill_in 'user_email', with: existing_user.email
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Sign up'
      end
    end

    it 'expects the page to be at the sign in path' do
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'expects the page to have the expected error message' do
      expect(page).to have_content(expected_error_message)
    end
  end
end
