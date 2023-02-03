# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  render_views

  let!(:user_attributes) { attributes_for(:user) }

  describe 'POST sign_up' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    context 'when successful' do
      it 'is expected to be redirect' do
        post :create, params: { user: user_attributes }
        expect(response).to be_redirect
      end

      it 'is expected to create a new user' do
        expect do
          post :create, params: { user: user_attributes }
        end.to change(User, :count).by(1)
      end

      it 'is expected to have flash message and current_user' do
        post :create, params: { user: user_attributes }
        expect(flash[:notice]).to be_an_instance_of(String).and eql(I18n.t('devise.registrations.signed_up'))
        expect(controller.current_user).to be_truthy.and be_a_kind_of(User)
      end
    end

    context 'when failure' do
      context 'user already exists' do
        let!(:existing_user) { create(:user) }
        let!(:expected_error_message) { "An account with that email (#{existing_user.email}) already exists. Please sign in or click the \"Forgot your password?\" link below."}
        let!(:existing_user_params) do
          {
            email: existing_user.email,
            first_name: existing_user.first_name,
            last_name: existing_user.last_name,
            password: 'password',
            password_confirmation: 'password'
          }
        end

        it 'is expected to redirect to new_user_session_path' do
          post :create, params: { user: existing_user_params }
          expect(response).to be_redirect.and redirect_to(new_user_session_path)
        end

        it 'is expected to have a flash message with expected error message' do
          post :create, params: { user: existing_user_params }
          expect(flash[:error]).to be_an_instance_of(String).and eql(expected_error_message)
        end

        it 'is expected not to have a current user' do
          post :create, params: { user: existing_user_params }
          expect(controller.current_user).to be(nil)
        end
      end

      context 'when missing required fields' do
        let!(:bad_user_params) { attributes_for(:user).except(:email) }

        it 'is expected to have error details in body' do
          post :create, params: { user: bad_user_params }
          expect(response.body).to have_selector("div[id=error_explanation]")
          expect(response.body).to have_content('1 error prohibited this user from being saved:')
          expect(response.body).to have_content("Email can't be blank")
        end

        it 'is expected to have the partial user attributes in the form' do
          post :create, params: { user: bad_user_params }
          expect(response.body).to have_field('user_first_name', with: bad_user_params[:first_name], visible: false)
          expect(response.body).to have_field('user_last_name', with: bad_user_params[:last_name], visible: false)
          expect(response.body).to have_field('user_password', visible: false)
          expect(response.body).to have_field('user_password_confirmation', visible: false)
          expect(response.body).to have_field('user_email', with: '', visible: false)
        end
      end
    end
  end
end
