Rails.application.routes.draw do
  root to: 'streams#index'
  resources :streams
  get '/streams/identify', to: 'streams#identify'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
