Rails.application.routes.draw do
  
  #루트 경로
  root 'home#index'

  devise_for :users
end
