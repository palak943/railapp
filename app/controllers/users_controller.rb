# app/controllers/users_controller.rb
class UsersController < ApplicationController
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        # Redirect to the desired page after successful registration
        redirect_to root_path, notice: 'User registration successful!'
      else
        render :new
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  