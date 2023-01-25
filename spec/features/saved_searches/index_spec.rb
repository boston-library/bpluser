# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Saved Searches', type: :feature, js: true do
  let!(:test_user) { create(:user, email: 'test@example.com', password: 'password', password_confirmation: 'password') }

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

  context "with a saved search 'book'" do
    before do
      within '.search-query-form' do
        fill_in 'Search...', with: 'book'
        click_button 'search'
      end

      within '#user-nav-btn' do
        find('button.dropdown-toggle').click
        click_on 'Search History'
      end

      click_button 'save'
      click_on 'Saved Searches'
    end

    it 'is expected to show saved searches' do
      expect(page).to have_content 'Your saved searches'
      expect(page).to have_content 'book'
    end

    it 'is expected to delete saved searches' do
      binding.pry
      find('a.delete_search').click
      expect(page).to have_content 'Search removed.'
    end

    describe "and a saved search 'dang'" do
      before do
        visit root_path
        fill_in 'q', with: 'dang'
        click_button 'search'
        click_link 'Search History'
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
