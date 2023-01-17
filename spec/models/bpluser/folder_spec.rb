# frozen_string_literal: true

require 'rails_helper'

describe Bpluser::Folder do
  let!(:user_attrs) do
    {
        email: 'testy@example.com',
        password: 'password',
        password_confirmation: 'password'
    }
  end

  let!(:folder_attrs) do
    {
      title: 'Test Folder Title',
      description: 'Test Description',
      visibility: 'public'
    }
  end

  let!(:user) { User.create!(user_attrs) }

  it 'is expected to create a new folder given valid attributes' do
    expect { user.folders.create!(folder_attrs) }.to change { described_class.count }.by(1)
  end

  describe 'user associations' do
    subject(:folder) { user.folders.create(folder_attrs) }

    it 'is expected to respond_to user attribute' do
      expect(folder).to respond_to(:user)
    end

    it 'is expected have the right associated user' do
      expect(folder.user_id).to be(user.id)
      expect(folder.user).to equal(user)
    end
  end

  describe 'validations' do
    it 'is expected to require a user id' do
      expect(described_class.new(folder_attrs)).not_to be_valid
    end

    it 'is expected to require a title' do
      expect(user.folders.build(title: '')).not_to be_valid
    end

    it 'is expected to reject titles that are too long' do
      expect(user.folders.build(title: 'a' * 41)).not_to be_valid
    end

    it 'is expected to reject descriptions that are too long' do
      expect(user.folders.build(title: 'Test Title', description: 'a' * 255)).not_to be_valid
    end
  end

  describe '#folder_items' do
    subject!(:folder) { user.folders.create!(folder_attrs) }

    let!(:folder_item) { folder.folder_items.create!(document_id: 'bpl-development:106') }

    it { is_expected.to respond_to(:folder_items) }

    it 'is expected to include the item in the folder_items relation' do
      expect(folder.folder_items).to include(folder_item)
    end
  end
end
