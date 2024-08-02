Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      post 'register', to: 'authentication#register'
      post 'login', to: 'authentication#login'


      # Users
      resources :users

      # Categories
      resources :categories

      # Books
      resources :books
    end
  end



  get "up" => "rails/health#show", as: :rails_health_check
end
