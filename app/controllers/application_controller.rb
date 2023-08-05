class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!
    def authenticate_user
        token = request.headers['Authorization']&.split&.last
    
        begin
          decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
          @current_user_id = decoded_token.first['user_id']
        rescue JWT::DecodeError
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      end
    
      def current_user
        @current_user ||= User.find(@current_user_id)
      end
end
