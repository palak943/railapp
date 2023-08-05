# app/controllers/users_controller.rb
class UsersController < ApplicationController
    # POST /users
    def create
      user = User.new(user_params)
  
      if user.save
        render json: { message: 'User created successfully' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # POST /login
    def login
      user = User.find_by(email: params[:email])
  
      if user&.authenticate(params[:password])
        token = generate_token(user.id)
        render json: { token: token }, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password)
    end
  
    def generate_token(user_id)
      payload = { user_id: user_id }
      JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
    end
  end
  