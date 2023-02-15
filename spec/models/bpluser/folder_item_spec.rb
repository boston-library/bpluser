# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bpluser::FolderItem do
  subject!(:folder_item) { build(:bpluser_folder_item, folder: folder) }

  let!(:test_user) { create(:user) }
  let!(:folder) { create(:bpluser_folder, user: test_user) }

  describe 'instance methods' do
    it { is_expected.to respond_to(:folder, :folder_id, :document, :document_id, :created_at, :updated_at).with(0).arguments }
  end

  describe 'database' do
    describe 'columns' do
      it { is_expected.to have_db_column(:folder_id).of_type(:integer) }
      it { is_expected.to have_db_column(:document_id).of_type(:string) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:folder_id) }
      it { is_expected.to have_db_index(:document_id) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:folder).inverse_of(:folder_items).class_name('Bpluser::Folder').touch(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:document_id) }
  end
end
