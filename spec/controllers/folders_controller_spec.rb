# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoldersController, type: :controller do
  render_views

  let!(:test_user) { create(:user) }

  describe 'GET index' do
    context 'when non-logged in user' do
      it 'is expected to link to the bookmarks folder' do
        get :index
        expect(response.body).to have_selector("a[href='/bookmarks']")
      end

      it 'is expected to not show any folders' do
        get :index
        expect(assigns(:folders)).to be_empty
      end
    end

    context 'when logged-in user' do
      before do
        sign_in test_user
      end

      describe 'user has no folders yet' do
        it 'is expected not to show any folders' do
          get :index
          expect(test_user.folders).to be_empty
          expect(assigns(:folders)).to be_empty
        end
      end

      describe 'user has folders' do
        before do
          create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user)
        end

        it 'is expected to show the users folders' do
          get :index
          expect(response.body).to have_selector("ul[id='user_folder_list']")
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user)
    end

    context 'when non-logged in user' do
      it 'is expected to redirect to the login page' do
        delete :destroy, params: { id: test_user.folders.first.id }
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path(referer_query_params(response)))
      end
    end

    context 'when logged-in user' do
      before do
        sign_in test_user
      end

      it 'is expected to delete the folder' do
        expect do
          delete :destroy, params: { id: test_user.folders.first.id }
        end.to change(Bpluser::Folder, :count).by(-1)
      end

      it 'is expected to redirect to the folders page' do
        delete :destroy, params: { id: test_user.folders.first.id }
        expect(response).to redirect_to(folders_path)
      end
    end
  end

  describe 'GET new' do
    before do
      sign_in test_user
    end

    it 'is expected to return http success' do
      get :new
      expect(response).to be_successful
    end

    it 'is expected to display the form' do
      get :new
      expect(response.body).to have_selector("form[id='edit_folder_form']")
    end
  end

  describe 'GET show' do
    context 'when non-logged in user' do
      describe 'private folder' do
        let!(:private_folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

        it 'is expected to redirect to the login page' do
          get :show, params: { id: private_folder.id }
          expect(response).to be_redirect
          expect(response).to redirect_to(root_path)
        end
      end

      describe 'public folder' do
        let!(:public_folder) { create(:bpluser_folder, title: 'Public Test Folder Title', visibility: 'public', user: test_user) }

        it 'is expected to show the folder' do
          get :show, params: { id: public_folder.id }
          expect(response.body).to have_selector('h2', text: public_folder.title)
        end
      end
    end

    context 'when logged-in user' do
      let!(:show_folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

      before do
        sign_in test_user
      end

      it 'is expected to show the folder title' do
        get :show, params: { id: show_folder.id }
        expect(response.body).to have_selector('h2', text: show_folder.title)
      end

      describe 'user has folder with items' do
        let!(:document_id) { 'bpl-dev:df65v790j' }

        before do
          create(:bpluser_folder_item, folder: show_folder, document_id: document_id)
          show_folder.reload
        end

        it 'should show a link to the folder item' do
          get :show, params: { id: show_folder.id }
          expect(response.body).to have_selector("a[href='/search/#{document_id}']")
        end
      end
    end

    context 'wrong user' do
      let!(:wrong_folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }
      let!(:other_user) { create(:user, email: 'testy@other.com', password: 'password', password_confirmation: 'password') }

      before do
        sign_in other_user
      end

      it 'is not expected to allow access to another users folder' do
        get :show, params: { id: wrong_folder.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST create' do
    context 'non-logged-in user' do
      it 'is expected to deny access to create' do
        post :create, params: { folder: { title: 'Some Title', visibility: 'public' } }
        expect(response).to redirect_to(new_user_session_path(referer_query_params(response)))
      end
    end

    context 'logged-in user' do
      before do
        sign_in test_user
      end

      describe 'failure' do
        it 'is expected not to create a folder' do
          expect do
            post :create, params: { folder: { title: ''} }
          end.not_to change(Bpluser::Folder, :count)
        end

        it 'is expected to re-render the create page' do
          post :create, params: { folder: { title: ''} }
          expect(response).to render_template('folders/new')
        end
      end

      describe 'success' do
        it 'is expected to create a folder' do
          expect do
            post :create, params: { folder: { title: 'Whatever, man', visibility: 'private' } }
          end.to change(Bpluser::Folder, :count).by(1)
        end

        it 'is expected to redirect to the folders page' do
          post :create, params: { folder: { title: 'Whatever, man', visibility: 'private' } }
          expect(response).to redirect_to(folders_path)
        end
      end
    end
  end

  describe 'GET edit' do
    let!(:edit_folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

    context 'when non-logged-in user' do
      it 'is expected to deny access to edit' do
       get :edit, params: { id: edit_folder.id }

       expect(response).to redirect_to(new_user_session_path(referer_query_params(response)))
      end
    end

    context 'when logged-in user' do
      before do
        sign_in test_user
      end

      it 'is expected to show the edit form with the correct title value' do
        get :edit, params: { id: edit_folder.id }
        expect(response.body).to have_field('folder_title', with: edit_folder.title)
      end
    end
  end

  describe 'PUT update' do
    let!(:put_folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'private', user: test_user) }

    context 'when non-logged-in user' do
      it 'is expected to deny access to update' do
        put :update, params: { id: put_folder.id, folder: { title: 'Change test folder title' } }
        expect(response).to redirect_to(new_user_session_path(referer_query_params(response)))
      end
    end

    context 'logged-in user' do
      before do
        sign_in test_user
      end

      context 'when failure' do
        it 'is expected not to update the folder' do
          put :update, params: { id: put_folder.id, folder: { title: '' } }
          put_folder.reload
          expect(put_folder.title).not_to eq('')
        end

        it 'is expected to re-render the edit form' do
          put :update, params: { id: put_folder.id, folder: { title: '' } }
          expect(response).to render_template('folders/edit')
        end
      end

      context 'when successful' do
        let!(:new_folder_title) { 'New Folder Title' }

        it 'is expected to update the folder' do
          put :update, params: { id: put_folder.id, folder: { title: new_folder_title } }
          put_folder.reload
          expect(put_folder.title).to eql(new_folder_title)
        end

        it 'is expected to redirect to the folders show page' do
          put :update, params:  { id: put_folder.id, folder: { title: new_folder_title } }
          expect(response).to redirect_to(folder_path(put_folder))
        end
      end
    end
  end

  describe 'GET public_list' do
    let!(:public_list_folder) { create(:bpluser_folder, title: 'Test Folder Title', visibility: 'public', user: test_user) }

    before do
      create(:bpluser_folder_item, folder: public_list_folder, document_id: 'bpl-test:gq67js019')
    end

    it 'is expected to show the public list' do
      get :public_list
      expect(response).to be_successful
      expect(response.body).to have_css('body.blacklight-folders-public_list')
    end

    it 'is expected to show the public folder in the list' do
      get :public_list
      expect(response.body).to have_selector('a', text: public_list_folder.title)
    end
  end
end
