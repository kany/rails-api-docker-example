Rails.application.routes.draw do
  match '/' => 'coins#add', via: :put
  match '/' => 'coins#remove', via: :delete

  resources :items, only: [:index, :update], path: :inventory
end
