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
    get 'revision_history', on: :member
    post 'save', on: :member
    resource :like, only: [:create, :destroy]

  end
  get 'count_likes', to: 'articles#count_likes'
  get 'search', to: 'articles#search'
  get 'filter_by_author', to: 'articles#filter_by_author'
  get 'filter_by_date', to: 'articles#filter_by_date'
  get 'filter_by_likes', to: 'articles#filter_by_likes'
  get 'filter_by_comments', to: 'articles#filter_by_comments'
  resources :authors, only: [:index, :show]

  resource :profile, only: [:show, :edit, :update]
  get 'my_posts', to: 'my_posts#index'
  resources :authors do
    resource :follow, only: [:create, :destroy]
  end
  resources :users, only: [:create]
  post '/login', to: 'users#login'

  get 'top_post', to: 'articles#top_post'
  get 'recommended_post', to: 'articles#recommended_post'
  get 'more_posts_by_author', to: 'articles#more_posts_by_author'
  get 'topic_list_page', to: 'articles#topic_list_page'
  get 'money_per_author', to: 'articles#money_per_author'
  get 'show_drafts', to: 'articles#show_drafts'
  get 'saved_articles', to: 'articles#saved_articles'

  resources :lists, except: [:destroy] do
    member do
      get :share
    end
  end

end
