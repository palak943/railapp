class MyPostsController < ApplicationController
    before_action :require_login

  def index
    @my_posts = current_user.posts
  end
end
