# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  render_views

  let!(:user_attributes) { attributes_for(:user) }

  describe 'POST sign_up' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe 'when successful' do
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
        expect(controller.current_user).to be_truthy.and be_an_instance_of(User)
      end
    end

    describe 'when failure' do
      let!(:bad_user_params) { attributes_for(:user).except(:email) }

      describe 'when missing recaptcha' do
        before do
          Recaptcha.configuration.skip_verify_env.delete('test')
          post :create, params: { user: bad_user_params }
        end

        after do
          Recaptcha.configuration.skip_verify_env << 'test'
        end

        it 'is expected to have error details in body' do
          expect(response.body).to have_css('div[id=error_explanation]')
          expect(response.body).to have_content(I18n.t('devise.registrations.recaptcha_error'))
        end

        it 'is expected to have the partial user attributes in the form' do
          expect(response.body).to have_field('user_last_name', with: bad_user_params[:last_name], visible: :all)
        end
      end

      describe 'when missing required fields' do
        before { post :create, params: { user: bad_user_params } }

        it 'is expected to have error details in body' do
          expect(response.body).to have_css('div[id=error_explanation]')
          expect(response.body).to have_content("Email can't be blank")
        end
      end
    end
  end
end
