class ArticlesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :require_login, only: [:edit, :update, :destroy]

    def index
        render json: Article.all
    end
    def create
        @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
    end
    def delete
        render json: Article.destroy_by(id: params[:id])
    end
    def search
        # Get the search query from the params
        search_query = params[:search]
    
        # Perform the search based on the name, topic, and author attributes
        @articles = Article.where("title LIKE ? OR category LIKE ? OR author LIKE ? OR text LIKE ?", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%")
    end
    def edit
        @article = Article.find(params[:id])
    end
    
    def update
        @article = Article.find(params[:id])
        if @article.update(article_params)
          redirect_to @article, notice: 'Article was successfully updated.'
        else
          render :edit
        end
    end
    def filter_by_author
        if params[:author_name]
            @articles = Article.joins(:author).where(authors: { name: params[:author_name] })
          else
            @articles = Article.all
        end
    end
    def filter_by_date
        if params[:start_date] && params[:end_date]
            @articles = Article.where(created_at: params[:start_date]..params[:end_date])
          else
            @articles = Article.all
        end
    end
    def filter_by_likes
        @articles = Article.all
        if params[:min_likes]
            @articles = @articles.where("likes_count >= ?", params[:min_likes])
        end
    end
    def filter_by_comments
        @articles = Article.all
        if params[:min_comments]
            @articles = @articles.where("comments_count >= ?", params[:min_comments])
        end
    end
    def like
        @article = Article.find(params[:id])
        @like = @article.likes.build(user: current_user)
    
        if @like.save
          redirect_to @article, notice: 'Article liked!'
        else
          redirect_to @article, alert: 'Failed to like article.'
        end
    end
    def unlike
        @article = Article.find(params[:id])
        @like = @article.likes.find_by(user: current_user)
    
        if @like.destroy
          redirect_to @article, notice: 'Article unliked.'
        else
          redirect_to @article, alert: 'Failed to unlike article.'
        end
    end
    def count_likes
        @article = Article.find(params[:id])
        @like_count = @article.likes.count
    end

    def create_comment
        @article = Article.find(params[:id])
        @comment = @article.comments.build(comment_params)
        @comment.user = current_user
    
        if @comment.save
          redirect_to @article, notice: 'Comment posted!'
        else
          redirect_to @article, alert: 'Failed to post comment.'
        end
    end
    private
   def article_params
    params.require(:article).permit(:title, :category, :image, :text, :author)
  end
  def require_login
    unless current_user
      render json: { error: 'Please log in first' }, status: :unauthorized
    end
  end
    
end
