# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FolderItemsController do
  render_views

  let!(:test_user) { create(:user) }
  let!(:folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

  before do
    sign_in test_user
  end

  describe 'POST create' do
    context 'when success' do
      let(:document_id) { 'bpl-dev:h702q6403' }
      let(:ajax_document_id) { 'bpl-dev:g445cd14k' }

      it 'is expected to create a new folder item' do
        expect do
          request.env['HTTP_REFERER'] = '/folder_items/new'
          post :create, params: { id: document_id, folder_id: folder.id.to_s }
          expect(response).to be_redirect
          expect(response).to redirect_to('/folder_items/new')
          expect(test_user.existing_folder_item_for(document_id)).not_to be_nil
        end.to change(Bpluser::FolderItem, :count).by(1)
      end

      it 'is expected to create a new folder item using ajax' do
        expect do
          post :create, xhr: true, params: { id: ajax_document_id, folder_id: folder.id.to_s }
          expect(response).to be_successful
          expect(test_user.existing_folder_item_for(ajax_document_id)).not_to be_nil
        end.to change(Bpluser::FolderItem, :count).by(1)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when successful' do
      let!(:document_id) { 'bpl-dev:g445cd14k' }

      before do
        create(:bpluser_folder_item, document_id: document_id, folder: folder)
      end

      it 'is expected to delete a folder item' do
        expect do
          request.env['HTTP_REFERER'] = '/folder_items'
          delete :destroy, params: { id: document_id }
          expect(response).to be_redirect
          expect(response).to redirect_to('/folder_items')
        end.to change(Bpluser::FolderItem, :count).by(-1)
      end

      it 'is expected to delete a folder item using ajax' do
        expect do
          delete :destroy, xhr: true, params: { id: document_id }
          expect(response).to be_successful
        end.to change(Bpluser::FolderItem, :count).by(-1)
      end
    end
  end

  describe 'DELETE clear' do
    context 'when successful' do
      let!(:document_id) { 'bpl-dev:g445cd14k' }

      before do
        create(:bpluser_folder_item, document_id: document_id, folder: folder)
      end

      it "is expected to clear the folder's folder items" do
        delete :clear, params: { id: folder.id }

        expect(folder.folder_items.count).to be_zero
      end
    end
  end
end
