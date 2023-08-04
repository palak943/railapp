class ApplicationController < ActionController::Base
    def current_user
        @current_user ||= User.find_by(id: decode_token)
    end
    def require_login
        unless current_user
          redirect_to login_path, alert: 'Please log in first.'
        end
    end
    
      private
    
      def decode_token
        token = request.headers['Authorization'].split(' ').last rescue nil
        begin
          decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
          decoded_token['user_id']
        rescue JWT::DecodeError
          nil
        end
      end
      
end
