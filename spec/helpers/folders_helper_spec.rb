# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoldersHelper do
  let!(:test_user) { create(:user, email: 'testy@test.com', password: 'password', password_confirmation: 'password') }
  let!(:wrong_user) { create(:user, email: 'testy2@test.com', password: 'password', password_confirmation: 'password') }
  let!(:folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

  describe '#folder_belongs_to_user' do
    describe 'correct user' do
      before do
        allow(helper).to receive(:current_or_guest_user).and_return(test_user)
      end

      it 'is expected to return true if the folder belongs to the current_or_guest_user' do
        expect(helper.folder_belongs_to_user(folder)).to be_truthy
      end
    end

    describe 'incorrect user' do
      before do
        allow(helper).to receive(:current_or_guest_user).and_return(wrong_user)
      end

      it 'is expected to return false if the folder does not belong to the current_or_guest_user' do
        expect(helper.folder_belongs_to_user(folder)).to be_falsey
      end
    end
  end
end
