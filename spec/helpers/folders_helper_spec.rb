require 'rails_helper'

describe FoldersHelper do
  let!(:test_user) { create(:user, email: 'testy@test.com', password: 'password', password_confirmation: 'password') }
  let!(:wrong_user) { create(:user, email: 'testy2@test.com', password: 'password', password_confirmation: 'password') }
  let!(:folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

  describe '#folder_belongs_to_user' do
    describe 'correct user' do
      before do
        allow(helper).to receive(:current_or_guest_user).and_return(test_user)
        helper.instance_variable_set(:@folder, folder)
      end

      after { helper.instance_variable_set(:@folder, nil) }

      it 'is expected to return true if the folder belongs to the current_or_guest_user' do
        expect(helper.folder_belongs_to_user).to be_truthy
      end
    end

    describe 'incorrect user' do
      before do
        allow(helper).to receive(:current_or_guest_user).and_return(wrong_user)
        helper.instance_variable_set(:@folder, folder)
      end

      after { helper.instance_variable_set(:@folder, nil) }

      it 'is expected to return false if the folder does not belong to the current_or_guest_user' do
        expect(helper.folder_belongs_to_user).to be_falsey
      end
    end
  end
end
