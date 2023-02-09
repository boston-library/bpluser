# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FolderItemsActionsController do
  render_views

  let!(:test_user) { create(:user) }
  let!(:folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }
  let!(:document_ids) { %w[bpl-dev:h702q6403 bpl-dev:g445cd14k bpl-dev:df65v790j] }

  before do
    document_ids.each { |doc_id| create(:bpluser_folder_item, document_id: doc_id, folder: folder) }
    sign_in test_user
  end

  describe 'folder_item_actions' do
    context 'when :remove' do
      context 'when successful' do
        it 'is expected remove the selected items' do
          expect do
            put :folder_item_actions, params: {
              commit: 'Remove',
              origin: 'folders',
              id: folder,
              selected: %w[bpl-dev:h702q6403 bpl-dev:g445cd14k]
            }
            expect(response).to be_redirect
          end.to change(folder.folder_items, :count).by(-2)
        end
      end
    end

    context 'when :copy' do
      let(:folder2) { create(:bpluser_folder, title: 'Other Test Folder Title', visibility: 'private', user: test_user) }

      context 'when successful' do
        it 'is expected to copy the selected items to folder2' do
          expect do
            request.env['HTTP_REFERER'] = "/folders/#{folder.id}"
            put :folder_item_actions, params: {
              commit: "Copy to #{folder2.id}",
              origin: 'folders',
              id: folder,
              selected: %w[bpl-dev:h702q6403 bpl-dev:g445cd14k]
            }
            expect(response).to be_redirect
            expect(response).to redirect_to("/folders/#{folder.id}")
          end.to change(folder2.folder_items, :count).by(2)
        end
      end
    end

    context 'when :cite' do
      context 'when successful' do
        it 'is expected to redirect to the cite url' do
          put :folder_item_actions, params: {
            commit: 'Cite',
            origin: 'folders',
            id: folder,
            selected: %w[bpl-dev:g445cd14k]
          }
          expect(response).to redirect_to(citation_solr_document_path(id: %w[bpl-dev:g445cd14k]))
        end
      end
    end

    context 'when :email' do
      context 'when successful' do
        it 'is expected to redirect to the email url' do
          put :folder_item_actions, params: {
            commit: 'Email',
            origin: 'folders',
            id: folder,
            selected: %w[bpl-dev:g445cd14k]
          }
          expect(response).to redirect_to(email_solr_document_path(id: %w[bpl-dev:g445cd14k]))
        end
      end
    end
  end
end
