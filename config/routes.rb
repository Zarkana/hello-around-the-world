Rails.application.routes.draw do
  devise_for :users
  get 'languages/index'
  post 'languages/destroy_logo'

  post 'snippets/:id/update_active', to: 'snippets#update_active'
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
  get 'quiz/answer', to: 'quiz#answer'
  get 'welcome/index'

  root 'quiz#index'
  #get '/quiz', to: 'controller_name#press'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
