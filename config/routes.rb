# frozen_string_literal: true

Rails.application.routes.draw do
  resources :omniauth_callbacks

  # folders
  get 'folders/public', to: 'folders#public_list', as: 'public_folders'
  resources :folders
  delete 'folder/:id/clear', to: 'folder_items#clear', as: 'clear_folder_items'
  put 'folder/:id/item_actions', to: 'folder_items_actions#folder_item_actions', as: 'selected_folder_items_actions'

  # folder items
  resources :folder_items

  # user account management (not login/auth)
  resources :users, only: [:show, :index]

  # saved searches -- no longer provided by blacklight >= 7
  delete "saved_searches/clear", to: "saved_searches#clear", as: "clear_saved_searches"
  get "saved_searches", to: "saved_searches#index", as: "saved_searches"
  put "saved_searches/save/:id", to: "saved_searches#save", as: "save_search"
  delete "saved_searches/forget/:id", to: "saved_searches#forget", as: "forget_search"
  post "saved_searches/forget/:id", to: "saved_searches#forget"
end
