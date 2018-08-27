Rails.application.routes.draw do

  #projects 경로
  resources :projects
  post 'projects/invite/:id' =>'projects#invite'
  post 'projects/exit/:id' => 'projects#exit'





  get 'projects/myproject' => 'projects#myproject'

  #posts 경로
  resources :posts do
    post "/like", to: "likes#like_toggle"

    #댓글기능 라우팅
    #post에 속한 라우팅 기능으므로 여기에 적어준다
    resources :comments, only: [:create, :destroy]
  end

  
  
  #루트 경로
  root :to => "home#index"
  get 'home/profile', to: 'home#profile', :as => :profile

  #devise 경로
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks'},
    path: 'users',
    path_name: {sign_in: 'login', sign_out: 'logout'}




  #register 경로
  get 'register/info', to: 'register#info', as: 'register_info'

  match '/profile/:id/finish_signup' => 'register#info', via: [:get, :patch], :as => :finish_signup

end
