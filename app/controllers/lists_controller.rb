# app/controllers/lists_controller.rb
class ListsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
  
    def index
      @lists = List.all
    end
  
    def show
      @list = List.find(params[:id])
    end
  
    def new
      @list = current_user.lists.build
    end
  
    def create
      @list = current_user.lists.build(list_params)
      if @list.save
        redirect_to @list, notice: "List was successfully created."
      else
        render :new
      end
    end
  
    def share
      @list = List.find(params[:id])
      # Logic to share the list, e.g., via email or social media
      # You can also use a gem for sharing functionality.
      # For example, you can use the 'shareable' gem.
    end
  
    private
  
    def list_params
      params.require(:list).permit(:name)
    end
  end
  