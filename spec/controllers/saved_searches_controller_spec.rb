# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SavedSearchesController, type: :controller do
  let!(:user) { create(:user, email: 'test@example.com', password: 'abcd12345', password_confirmation: 'abcd12345') }
  let!(:searches) { create_list(:search, 3, user: user) }
  let!(:one) { searches[0] }
  let!(:two) { searches[1] }
  let!(:three) { searches[2] }

  before do
    sign_in user
  end

  describe 'save' do
    before do
      request.env['HTTP_REFERER'] = 'where_i_came_from'
    end

    it 'lets you save a search' do
      session[:history] = [one.id]
      post :save, params: { id: one.id }
      expect(response).to redirect_to 'where_i_came_from'
    end

    it "does not let you save a search that isn't in your search history" do
      session[:history] = [one.id]
      expect do
        post :save, params: { id: two.id }
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
