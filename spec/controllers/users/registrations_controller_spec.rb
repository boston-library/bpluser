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
        post :create, params: { sign_up: user_attributes }
        expect(response).to be_redirect
      end

      it 'is expected to create a new user' do
        expect do
          post :create, params: { sign_up: user_attributes }
          binding.pry
        end.to change(User, :count).by(1)
      end

      it 'is expected to have flash message and current_user' do
        post :create, params: { sign_up: user_attributes }
        expect(flash[:notice]).to be_an_instance_of(String)
        expect(controller.current_user).to be_truthy.and be_a_kind_of(User)
      end
    end

    skip 'when failure' do
    end
  end
end
