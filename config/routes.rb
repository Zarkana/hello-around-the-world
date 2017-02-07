Rails.application.routes.draw do
  # resources :snippets do
  #   resources :implementations
  # end
  resources :snippets

  get 'study/index'

  get 'quiz/index'
  get 'quiz/question', to: 'quiz#question'
  get 'quiz/answer', to: 'quiz#answer'
  get 'welcome/index'

  root 'quiz#index'
  #get '/quiz', to: 'controller_name#press'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
