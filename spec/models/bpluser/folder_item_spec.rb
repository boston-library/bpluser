# frozen_string_literal: true

require 'rails_helper'

describe Bpluser::FolderItem do
  let!(:test_user_attrs) do
    {
      email: 'testy@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  let!(:folder_attrs) do
    {
      title: 'Test Title',
      description: 'Test Description',
      visibility: 'public'
    }
  end

  let!(:folder_item_attrs) do
    {
      document_id: 'bpl-development:107'
    }
  end

  let!(:test_user) { User.create!(test_user_attrs) }
  let!(:folder) { test_user.folders.create!(folder_attrs) }

  it 'is expected to create a new folder_item given valid attributes' do
    expect { folder.folder_items.create(folder_item_attrs) }.to change { described_class.count }.by(1)
  end

  describe 'instance methods' do
    subject(:folder_item) { folder.folder_items.create(folder_item_attrs) }

    it { is_expected.to respond_to(:folder, :document) }
  end
end
