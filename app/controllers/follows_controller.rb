class FollowsController < ApplicationController
    before_action :require_login

  def create
    @author = Author.find(params[:author_id])
    current_user.authors << author
    redirect_to author_path(author), notice: 'You are now following this author.'
  end

  def destroy
    @follow = Follow.find_by(user: current_user, author_id: params[:author_id])
    if @follow
      @follow.destroy
      redirect_to author_path(params[:author_id]), notice: 'You have unfollowed this author.'
    else
      redirect_to author_path(params[:author_id]), alert: 'You are not following this author.'
    end
  end
end
