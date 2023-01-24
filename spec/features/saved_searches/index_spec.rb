# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Saved Searches', type: :feature, js: true do
  let!(:test_user) { create(:user, email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  before do
    sign_in test_user
    visit root_path
  end

  it 'is empty' do
    click_on '#user-nav-btn'
    within '#user-nav-btn' do
      click_button
      select 'Saved Searches', from: 'user-util-links-list'
    end
    expect(page).to have_content 'You have no saved searches'
  end

  context "with a saved search 'book'" do
    before do
      within '.search-query-form' do
        fill_in '#q', with: 'book'
        click_button 'search'
      end
      click_link 'History'
      click_button 'save'
      click_link 'Saved Searches'
    end

    it 'is expected to show saved searches' do
      expect(page).to have_content 'Your saved searches'
      expect(page).to have_content 'book'
    end

    it 'is expected to delete saved searches' do
      click_button 'delete'
      expect(page).to have_content 'Successfully removed that saved search.'
    end

    describe "and a saved search 'dang'" do
      before do
        visit root_path
        fill_in 'q', with: 'dang'
        click_button 'search'
        click_link 'History'
        click_button 'save'
        click_link 'Saved Searches'
      end

      it 'is expected to clear the searches' do
        click_link 'Clear Saved Searches'
        expect(page).to have_content 'Cleared your saved searches.'
        expect(page).to have_content 'You have no saved searches'
      end
    end
  end
end
