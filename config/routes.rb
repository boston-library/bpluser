# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations', sessions: 'users/sessions' }

  # folders
  resources :folders do
    get 'public', on: :collection, action: :public_list
  end

  delete 'folder/:id/clear', to: 'folder_items#clear', as: 'clear_folder_items'
  put 'folder/:id/item_actions', to: 'folder_items_actions#folder_item_actions', as: 'selected_folder_items_actions'

  # folder items
  resources :folder_items

  # user account management (not login/auth)
  resources :users, only: [:show]

  # saved searches -- no longer provided by blacklight >= 7
  get 'saved_searches', to: 'saved_searches#index', as: 'saved_searches'
  put 'saved_searches/save/:id', to: 'saved_searches#save', as: 'save_search'
  post 'saved_searches/forget/:id', to: 'saved_searches#forget'
  delete 'saved_searches/forget/:id', to: 'saved_searches#forget', as: 'forget_search'
  delete 'saved_searches/clear', to: 'saved_searches#clear', as: 'clear_saved_searches'
end
