# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registering a new User', :js do
  context 'when new User' do
    let!(:new_user_attributes) { attributes_for(:user) }

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
          click_on 'Sign up'
        end
      end

      it 'expects the page to have the successful sign up message' do
        expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
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
            click_on 'Sign up'
          end
        end

        it 'expects the page to have errors with missing attributes' do
          expect(page).to have_content(email_error)
          expect(page).to have_content(password_error)
        end

        it 'expects the page to be at the sign up path' do
          expect(page).to have_current_path(user_registration_path) # Investigate why the path is /users instead of /users/sign_up
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
            click_on 'Sign up'
          end
        end

        it 'expects the page to have error about password confirmation' do
          expect(page).to have_content(password_conf_error)
        end

        it 'expects the page to be at the sign up path' do
          expect(page).to have_current_path(user_registration_path)
        end
      end
    end
  end

  context 'when User already exists' do
    let!(:existing_user) { create(:user) }

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
        click_on 'Sign up'
      end
    end

    it 'expects the page to be at the sign in path' do
      expect(page).to have_current_path(user_registration_path)
    end

    it 'expects the page to have the expected error message' do
      expect(page).to have_content('Email has already been taken')
    end
  end
end
