class AuthenticationController < ApplicationController
    def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = encode_token(user.id)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    
      private
    
      def encode_token(user_id)
        JWT.encode({ user_id: user_id }, Rails.application.secrets.secret_key_base)
      end
end
