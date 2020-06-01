AnnotationStudio::Application.routes.draw do

  resources :anthologies do
    resources :documents
  end
  get "api/me"

  use_doorkeeper

  get 'public/:id' => 'public_documents#show'
  get 'review/:id' => 'public_documents#show'

  devise_for :users, controllers: {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'}

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_scope :user do
    match '/users/auth/wordpress_hosted/setup' => 'omniauth_callbacks#setup', via: :all, as: 'wordpress_host_setup'
  end
  ActiveAdmin.routes(self)

  # catalog routes
  get 'documents/catalog', to: 'catalog#index'
  get 'documents/catalog/image/:eid', to: 'catalog#image'
  get 'documents/catalog/reference/:eid', to: 'catalog#reference'
  post 'anthology_add', to: 'documents#anthology_add'
  post 'user_anthology_add', to: 'users#anthology_add'
  post 'remove_user', to: 'users#remove_user'
  post 'remove_doc', to: 'anthologies#remove_doc'
  post 'remove_anthology_user', to: 'anthologies#remove_user'
  post 'add_anthology_user', to: "anthologies#add_user"

  resources :documents do
    resources :annotations
    post :set_default_state
    post :publish
    post :annotatable
    post :review
    post :archive
    post :snapshot
    get :export
    get :preview, to: 'documents#preview'
    get :post_to_cove, to: 'documents#post_to_cove'
  end

  resources :users, only: [:index, :show, :edit]

  authenticated :user do
    root :to => "users#show"
    get 'dashboard', to: 'users#show', as: :dashboard
    get 'annotations', to: 'annotations#index'
    get 'annotations/:id', to: 'annotations#show'
    get 'documents/:document_id/annotations/field/:field', to: 'annotations#field'
    get 'groups', to: 'groups#index'
    get 'groups/:id', to: 'groups#show'
  end

  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"
    end
  end

	get 'exception_test' => "annotations#exception_test"
  # root :to => "devise/sessions#new"

  get '/admin/autocomplete_tags',
    to: 'admin/students#autocomplete_tags',
    as: 'autocomplete_tags'

end
