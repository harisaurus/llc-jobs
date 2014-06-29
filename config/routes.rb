LlcJobboard::Application.routes.draw do
  devise_for :admins, :path => 'admin', :path_names => { sign_in: '' }
  devise_for :users

  root 'job_posts#index'

  resources :job_posts do
    collection do
      get 'user_posts'
    end

    member do
      post 'charge'
      post 'feature'
      put 'hide_or_show'
    end
  end

  resources :job_applications, only: [:create, :show, :index]

  get 'style' => 'pages#style_guide'

  get 'tags/:tag', to: 'job_posts#index', as: :tag

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    get 'dashboard/edit' => 'dashboard#edit'
    patch 'dashboard' => 'dashboard#update_password'
    get 'new' => 'dashboard#new_admin'
    post 'create' => 'dashboard#create_admin'

    resources :categories
    resources :job_types

    resources :job_posts do
      member do
        put 'activate'
        put 'reject'
        put 'hide_or_show'
      end
    end
  end
end
