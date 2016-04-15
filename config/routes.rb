Bpluser::Engine.routes.draw do
  post 'sdf', :to => 'api#sdf', :as => 'sdf_request'
end
