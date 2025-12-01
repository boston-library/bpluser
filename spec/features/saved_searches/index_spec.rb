# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Saved Searches', :js do
  let!(:test_user) { create(:user, email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  before do
    skip 'skipping until issue with Selenium::WebDriver::Error::StaleElementReferenceError is resolved'
    sign_in test_user
    visit root_path
  end

  context 'with no saved searches' do
    it 'is empty' do
      within '#user-nav-btn' do
        click_on(class: 'dropdown-toggle')
        click_on 'Saved Searches'
      end

      expect(page).to have_content "You don't have any saved searches at the moment"
    end
  end

  context "with a saved search 'book'" do
    before do
      within 'form.search-query-form' do
        fill_in 'Search...', with: 'book'
        click_on 'search'
      end

      within '#user-nav-btn' do
        find('button.dropdown-toggle-split').click
        click_on 'Search History'
      end

      click_on 'save'
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
      within '.search-query-form' do
        fill_in 'Search...', with: 'dang'
        click_on 'search'
      end

      within '#user-nav-btn' do
        find('button.dropdown-toggle-split').click
        click_on 'Search History'
      end

      click_on 'save'
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
