# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration/Log in with Omniauth Polaris', :js do
  before do
    visit new_user_session_path
  end

  describe 'sucessful sign in' do
    context 'when new User' do
      it 'expects a new user to be created on sign in' do
        expect do
          click_link 'Log in with your BPL library card'
          expect(page).to have_content('Successfully authenticated from Polaris account.')
          expect(page).to have_current_path(root_path)
        end.to change(User, :count).by(1)
      end

      it 'expects the new User to have a polaris provider and uid set' do
        click_link 'Log in with your BPL library card'
        expect(User.last.provider).to be_a(String).and eql('polaris')
        expect(User.last.uid).to be_a(String)
      end
    end

    context 'when existing User' do
      it 'expects the existing user to not be created on sign in' do
        create(:user, :polaris_user)
        expect do
          click_link 'Log in with your BPL library card'
          expect(page).to have_content('Successfully authenticated from Polaris account.')
          expect(page).to have_current_path(root_path)
        end.not_to change(User, :count)
      end
    end
  end
end
