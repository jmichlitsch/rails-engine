Rails.application.routes.draw do
  namespace :api do
   namespace :v1 do
     get 'merchants/find', to: 'merchants#find'
     get 'merchants/find_all', to: 'merchants#find_all'
     resources :merchants, only: [:index, :show] do
       resources :items, only: :index
     end

     resources :items do
        resource :merchant, only: :show
      end
   end
 end
end
