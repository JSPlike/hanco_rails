# frozen_string_literal: true

class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end
  [:kakao, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end
  
  # provider별로 서로 다른 로그인 경로 설정

  def after_sign_in_path_for(resource)
    
    auth = request.env['omniauth.auth']
    @identity = Identity.find_for_oauth(auth)
    @user = User.find(current_user.id)
    
    if @user.persisted?
      if @identity.provider == "kakao"
        new_user_registration_path
      else
        new_user_registration_path
      end
    else
      root_path
    end
  end
end
