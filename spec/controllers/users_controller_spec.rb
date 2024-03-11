# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  render_views

  let!(:test_user) { create(:user) }

  describe 'Get show' do
    describe 'non-logged-in user' do
      it 'is expected to redirect to the sign-in page' do
        get :show, params: { id: test_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'logged-in user' do
      describe 'trying to view wrong account' do
        let!(:test_user2) { create(:user, email: 'testy2@example.com', password: 'password', password_confirmation: 'password') }

        before do
          sign_in test_user
        end

        it 'is expected to redirect to the home page' do
          get :show, params: { id: test_user2.id }
          expect(response).to redirect_to(root_path)
        end
      end

      describe 'viewing correct account' do
        before do
          sign_in test_user
        end

        it 'is expected to show the user#show page' do
          get :show, params: { id: test_user.id }
          expect(response).to be_successful
          expect(response.body).to have_css('#user_account_links_list')
        end
      end
    end
  end
end
