Lifelist::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  root to: 'explore#index', :as => "explore"
  get 'terms' => 'main#terms'
  get 'privacy' => 'main#privacy'
  resources 'invite_requests'

  resources :goals do
    get 'featured', :on => :collection
    member do
      get 'pathways'
      put 'add_to_lifelist'
      put 'add_to_doneit'
      put 'toggle_vote'
      put 'crop'
    end
  end
  match 'explore' => 'explore#index'
  match 'explore/:topic' => 'explore#topic'
  scope "api" do
    resources :categories, only: [:index]
  end

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :users, only: [:update]
  get '/profile/edit' => 'users#edit', as: :edit_profile

  match ':username' => 'users#show', as: :profile
  namespace :users, path: ':username' do
    resources :goals do
      get 'featured', :on => :collection
      member do
        get 'autoassign_image'
        put 'sort'
      end
      resources :steps do
        put 'sort', on: :member
      end
    end
  end
end
