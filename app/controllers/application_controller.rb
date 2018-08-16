class ApplicationController < ActionController::Base
	## devise에서 새로추가한 컬럼의 파라미터를 받을때 사용한다.
	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?

	#권한이 없는 사용자가 접근하면 플래쉬 메시지
	def authority_forbidden(error)
  	Authority.logger.warn(error.message)
  	redirect_to request.referrer.presence || root_path, :alert => 'You are not authorized to complete that action.'
	end
  
	protected

	def configure_permitted_parameters
    	devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    	devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end
