# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  render_views

  let!(:user_attributes) { attributes_for(:user) }


  describe 'POST sign_up' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    context 'success' do
      it 'is expected to redirect to after_sign_in_path' do
        post :create, params: { user: user_attributes }
        expect(response).to be_redirect
      end

      it 'is expected to create a new user' do
        expect do
          post :create, params: { user: user_attributes }
        end.to change(User, :count).by(1)
      end
    end
  end
end
