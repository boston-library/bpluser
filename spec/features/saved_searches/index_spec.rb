# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Saved Searches', type: :feature, js: true do
  let!(:test_user) { create(:user, email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  context 'with no saved searches' do
    before do
      sign_in test_user
      visit root_path
    end

    it 'is empty' do
      within '#user-nav-btn' do
        find('button.dropdown-toggle').click
        click_on 'Saved Searches'
      end

      expect(page).to have_content "You don't have any saved searches at the moment"
    end
  end

  context "with a saved search 'book'" do
    before do
      sign_in test_user
      visit root_path
      within '.search-query-form' do
        fill_in 'Search...', with: 'book'
        click_button 'search'
      end

      within '#user-nav-btn' do
        find('button.dropdown-toggle').click
        click_on 'Search History'
      end

      click_button 'save'
    end

    it 'is expected to show saved searches' do
      visit saved_searches_path
      expect(page).to have_content 'Your saved searches'
      expect(page).to have_content 'book'
    end

    it 'is expected to delete saved searches individually' do
      visit saved_searches_path
      find('a.delete_search').click
      expect(page).to have_content 'Search removed.'
    end
  end

  context "with a saved search 'dang'" do
    before do
      sign_in test_user
      visit root_path
      within '.search-query-form' do
        fill_in 'Search...', with: 'dang'
        click_button 'search'
      end

      within '#user-nav-btn' do
        find('button.dropdown-toggle').click
        click_on 'Search History'
      end

      click_button 'save'
    end

    it 'is expected to clear all saved searches' do
      visit saved_searches_path

      accept_confirm do
        click_on 'Clear All'
      end

      expect(page).to have_content 'Cleared your saved searches.'
      expect(page).to have_content "You don't have any saved searches at the moment"
    end
  end
end
