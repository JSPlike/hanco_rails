class ApplicationController < ActionController::Base
	## devise에서 새로추가한 컬럼의 파라미터를 받을때 사용한다.
	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?

  
	protected

	def configure_permitted_parameters
    	devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    	devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end
