Rails.application.routes.draw do

  mount Ckeditor::Engine => "/ckeditor"
  scope "(:locale)", locale: /en|vi/ do
    root "homes#index"
    get 'search_issues/search'
    get "/register", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/new_project", to: "projects#new"
    post "/new_project", to: "projects#create"
    get "/auth/:provider/callback", to: "sessions#create"
    get "/auth/failure", to: "sessions#failure"

    resources :projects
    resources :add_times, only: [:edit]
    resources :show_descriptions, only: [:show]
    resources :actions, only: [:index]
    resources :my_pages, only: [:show]
    resources :issue_templates do
      resources :users
    end
    resources :emojis
    resources :issue_relationships


    resources :sessions do
      collection do
        get :receive
      end
    end
    resources :pictures
    resources :issues do
      collection do
        delete :destroy_multiple
        put :add_time
        get :search
        get :choose_type_issue
        get :choose_template
      end
    end
    resources :users do
        member do
            get :block
        end
      end

  end
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]


end
