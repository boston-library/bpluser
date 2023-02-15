# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bpluser::Folder do
  subject!(:folder) { build(:bpluser_folder, folder_attrs) }

  let!(:test_user) { create(:user) }
  let!(:folder_attrs) { attributes_for(:bpluser_folder, user: test_user) }

  describe 'class constants' do
    subject { described_class }

    it { is_expected.to be_const_defined(:MAX_TITLE_LENGTH) }
    it { is_expected.to be_const_defined(:MAX_DESC_LENGTH) }
    it { is_expected.to be_const_defined(:VALID_VISIBILITY_OPTS) }

    describe ':MAX_TITLE_LENGTH' do
      subject { described_class.const_get(:MAX_TITLE_LENGTH) }

      it { is_expected.to be_an_instance_of(Integer) }
    end

    describe ':MAX_DESC_LENGTH' do
      subject { described_class.const_get(:MAX_DESC_LENGTH) }

      it { is_expected.to be_an_instance_of(Integer) }
    end

    describe ':VALID_VISIBILITY_OPTS' do
      subject { described_class.const_get(:VALID_VISIBILITY_OPTS) }

      it { is_expected.to be_an_instance_of(Array).and all(be_an_instance_of(String)).and be_frozen }
    end
  end

  describe 'instance methods' do
    it { is_expected.to respond_to(:user, :user_id, :title, :description, :created_at, :updated_at, :visibility, :folder_items, :public?, :private?).with(0).arguments }
    it { is_expected.to respond_to(:folder_item?).with(1).argument }

    describe '#public?' do
      before do
        folder.visibility = 'public'
      end

      it 'is expected to be public' do
        expect(folder).to be_public
        expect(folder).not_to be_private
      end
    end

    describe '#private?' do
      before do
        folder.visibility = 'private'
      end

      it 'is expected to be private' do
        expect(folder).to be_private
        expect(folder).not_to be_public
      end
    end
  end

  describe 'database' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:string) }
      it { is_expected.to have_db_column(:visibility).of_type(:string) }

      it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:user_id) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user).inverse_of(:folders).class_name('::User') }

    it { is_expected.to have_many(:folder_items).inverse_of(:folder).dependent(:destroy).class_name('Bpluser::FolderItem') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:visibility) }

    it { is_expected.to validate_length_of(:title).is_at_most(described_class.const_get(:MAX_TITLE_LENGTH)) }
    it { is_expected.to validate_length_of(:description).is_at_most(described_class.const_get(:MAX_DESC_LENGTH)) }

    it { is_expected.to validate_inclusion_of(:visibility).in_array(described_class.const_get(:VALID_VISIBILITY_OPTS)) }
  end

  describe 'scopes' do
    describe '.with_folder_items' do
      subject { described_class.with_folder_items.to_sql }

      let(:expected_sql) { described_class.includes(:folder_items).to_sql }

      it { is_expected.to eql(expected_sql) }
    end

    describe '.public_list' do
      subject { described_class.public_list.to_sql }

      let(:expected_sql) { described_class.includes(:folder_items).where(visibility: 'public').order(updated_at: :desc).to_sql }

      it { is_expected.to eql(expected_sql) }
    end
  end
end
