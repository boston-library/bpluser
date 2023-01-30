# frozen_string_literal: true

FactoryBot.define do
  factory :bpluser_folder_item, class: 'Bpluser::FolderItem' do
    association :folder, factory: :bpluser_folder
    document_id { "bpl-development:#{Random.hex(3)}" }
  end
end
