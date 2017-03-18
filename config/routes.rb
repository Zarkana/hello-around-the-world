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

  resources :quizzes

  get 'categories/index'

  get 'study/index'

  get 'quizzes/index'
  get 'quizzes/question', to: 'quizzes#question'
  get 'quizzes/manage', to: 'quizzes#manage'
  get 'quizzes/answer', to: 'quizzes#answer'
  get 'welcome/index'

  root 'quizzes#new'
  #get '/quizzes', to: 'controller_name#press'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
