# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  before(:all) do
    OmniAuth.config.on_failure = Proc.new { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
  end

  describe 'POST #polaris' do
    context 'when user does not exist' do
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:polaris]
      end

      it 'is expected to create a new user' do
        expect do
          post :polaris
        end.to change(User, :count).by(1)
      end

      it 'is expected to set the flash notice' do
        post :polaris
        expect(flash[:notice]).to be_truthy
        expect(flash[:notice]).to eql(I18n.t('devise.omniauth_callbacks.success', kind: 'Polaris'))
      end

      it 'is expected to have current user' do
        post :polaris
        expect(subject.current_user).to be_truthy.and be_an_instance_of(User)
      end
    end

    context 'when user already exists' do
      let!(:user) { create(:user, :polaris_user) }

      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:polaris]
      end

      it 'is expected not to create a new user' do
        expect do
          post :polaris
        end.not_to change(User, :count)
      end

      it 'is expected to set the flash notice' do
        post :polaris
        expect(flash[:notice]).to be_truthy
        expect(flash[:notice]).to eql(I18n.t('devise.omniauth_callbacks.success', kind: 'Polaris'))
      end

      it 'is expected for the current user to equal the user' do
        post :polaris
        expect(subject.current_user).to eql(user)
      end
    end

    context 'when failure' do
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ uid: nil, provider: 'polaris', info: {}, extra: {} })
      end

      it 'is expected to redirect to new_user_session_path' do
        post :polaris
        expect(response).to redirect_to(new_user_registration_url)
      end

      it 'is expected to have devise.polaris_data in the session' do
        post :polaris
        expect(session).to have_key('devise.polaris_data')
        expect(session['devise.polaris_data']).to be_a_kind_of(OmniAuth::AuthHash)
      end
    end
  end
end
