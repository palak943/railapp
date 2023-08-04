Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #root "articles#home"
  root "articles#index"
  post 'create', to: 'articles#create'
  resources :articles do
    post 'like', on: :member
    delete 'unlike', on: :member
    post 'create_comment', on: :member
  end
  get 'count_likes', to: 'articles#count_likes'
  get 'search', to: 'articles#search'
  get 'filter_by_author', to: 'articles#filter_by_author'
  get 'filter_by_date', to: 'articles#filter_by_date'
  get 'filter_by_likes', to: 'articles#filter_by_likes'
  get 'filter_by_comments', to: 'articles#filter_by_comments'
  
  resources :authors, only: [:index, :show]

  post 'login', to: 'authentication#login'

  resources :users, only: [:new, :create]

  resource :profile, only: [:show, :edit, :update]
  get 'my_posts', to: 'my_posts#index'
  resources :authors do
    resource :follow, only: [:create, :destroy]
  end
end
