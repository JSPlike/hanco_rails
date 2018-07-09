Rails.application.routes.draw do
  
  #projects 경로
  resources :projects
  
  #posts 경로
  resources :posts
  
  #루트 경로
  root :to => "home#index"

  #devise 경로
  devise_for :users,

  #경로설정 costomizing
  path: 'users',
  path_name: {sign_in: 'login', sign_out: 'logout'}

end
