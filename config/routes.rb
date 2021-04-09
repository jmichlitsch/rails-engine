Rails.application.routes.draw do
  namespace :api do
   namespace :v1 do
     get 'merchants/find', to: 'merchants#find'
     get 'merchants/find_all', to: 'merchants#find_all'
     get 'merchants/most_items', to: 'merchants#most_items'
     resources :merchants, only: [:index, :show] do
       resources :items, only: :index
     end

     get 'items/find', to: 'items#find'
     get 'items/find_all', to: 'items#find_all'
     resources :items do
        resource :merchant, only: :show
      end

      get 'revenue', to: 'revenue#revenue'
      get 'revenue/items', to: 'revenue#items'
      get 'revenue/unshipped', to: 'revenue#unshipped'
      get 'revenue/weekly', to: 'revenue#weekly'
      get 'revenue/merchants', to: 'revenue#merchants'
      get 'revenue/merchants/:id', to: 'revenue#merchant_revenue'
   end
 end
end
