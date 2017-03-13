Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  get 'languages/index'
  post 'languages/destroy_logo'

  post 'snippets/:id/update_active', to: 'snippets#update_active'
  post 'snippets/:id/update_snippet', to: 'snippets#update_snippet'
  post 'snippets/:id/add_snippet', to: 'snippets#add_snippet'
  post 'categories/:id/update_active', to: 'categories#update_active'

  # resources :snippets do
  #   resources :implementations
  # end
  resources :snippets

  resources :languages

  resources :categories

  get 'categories/index'

  get 'study/index'

  get 'quiz/index'
  get 'quiz/question', to: 'quiz#question'
  get 'quiz/manage', to: 'quiz#manage'
  get 'quiz/answer', to: 'quiz#answer'
  get 'welcome/index'

  root 'quiz#index'
  #get '/quiz', to: 'controller_name#press'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
