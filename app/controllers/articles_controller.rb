class ArticlesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :require_login, only: [:edit, :update, :destroy]

    def index
        render json: Article.where(status: 'published')
    end
    def create
        @article = Article.new(article_params)
        if params[:commit] == 'Save as Draft'
          @article.status = 'draft'
        end
    
        if @article.save
          render json: @article, status: :published
        else
          render json: @articles.errors.full_messages.each 
        end
    end
    def destroy
      @article = Article.find(params[:id])
      @article.destroy
      head :no_content
    end
    def search
        # Get the search query from the params
        search_query = params[:search]
    
        # Perform the search based on the name, topic, and author attributes
        @articles = Article.where("title LIKE ? OR category LIKE ? OR author LIKE ? OR text LIKE ?", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%")
        render json: @articles
    end
    def edit
        @article = Article.find(params[:id])
    end
    
    def update
      @article = Article.find(params[:id])
      if params[:commit] == 'Save as Draft'
        @article.status = 'draft'
      end
  
      if @article.update(article_params)
        redirect_to @article
      else
        render 'edit'
      end
    end
    def filter_by_author
        if params[:author_name]
            @articles = Article.joins(:author).where(authors: { name: params[:author_name] })
          else
            @articles = Article.all
        end
        render json: @articles
    end
    def filter_by_date
        if params[:start_date] && params[:end_date]
            @articles = Article.where(created_at: params[:start_date]..params[:end_date])
          else
            @articles = Article.all
        end
        render json: @articles
    end
    def filter_by_likes
        @articles = Article.all
        if params[:min_likes]
            @articles = @articles.where("likes_count >= ?", params[:min_likes])
        end
        render json: @articles
    end
    def filter_by_comments
        @articles = Article.all
        if params[:min_comments]
            @articles = @articles.where("comments_count >= ?", params[:min_comments])
        end
        render json: @articles
    end
    def like
        @article = Article.find(params[:id])
        @like = @article.likes.build(user: current_user)
    
        if @like.save
          render json: @article, notice: 'Article liked!'
        else
          render json: @article, alert: 'Failed to like article.'
        end
    end
  def unlike
      @article = Article.find(params[:id])
      @like = @article.likes.find_by(user: current_user)
  
      if @like.destroy
        render json: @article, notice: 'Article unliked.'
      else
        render json: @article, alert: 'Failed to unlike article.'
      end
  end
  def count_likes
      @article = Article.find(params[:id])
      @like_count = @article.likes.count
      render json: @like_count
  end

  def create_comment
        @article = Article.find(params[:id])
        @comment = @article.comments.build(comment_params)
        @comment.user = current_user
    
        if @comment.save
          render json: @article, notice: 'Comment posted!'
        else
          render json: @article, alert: 'Failed to post comment.'
        end
  end

  def top_post
    @top_posts = Article.where('created_at >= ?', 24.hours.ago).order(likes_count: :desc)
    render json: @top_posts
  end
  def recommended_post
    @category = params[:category]
    @authors= params[:author]
    @articles =  Article.where('category = :category OR author = :author', category: @category, author: @author).order(likes_count: :desc)
    render json: @articles
  end
  def more_posts_by_author
    @article = Article.find(params[:article_id])
    @authors= params[:author]
    @more_articles =Article.where(author: @authors).where.not(id: @article.id)
    render json: @more_articles
  end
  def topic_list_page
    @categories = Article.distinct.pluck(:category)
    @categories.each do |category|
      @articles=Article.where(category: category)
      render json: @articles
    end
  end
  # money_per_author: One of the suitable ways to divide the money among the creators is on the engagement they bring to the platform.
  #So basically I have calculated the total number of likes and comments in the last one month and then calculated the total number of likes and comments per author 
  #then calculated the total number of likes and comments per author in the last one month 
  # Then displaying the percent of total money 
  def money_per_author
    @likes_in_last_month = Like.where(created_at: 1.month.ago..Time.now).count
    @comments_in_last_month = Comment.where(created_at: 1.month.ago..Time.now).count
    @total=@likes_in_last_month+@comments_in_last_month
    @authors = Article.distinct.pluck(:author)
    @authors.each do |author|
      @likes_in_last_month_by_author = Like.where(created_at: 1.month.ago..Time.now).where(author: author).count
      @comments_in_last_month_by_author = Comment.where(created_at: 1.month.ago..Time.now).where(author: author).count
      @get_percent= (@likes_in_last_month_by_author +@comments_in_last_month_by_author)/@total *100
      render json: @get_percent
    end
  end
  def show_drafts
    @articles = Article.where(status: 'draft')
    render json: @articles
  end
  def revision_history
    @article = Article.find(params[:id])

  end
  def save
    @article = Article.find(params[:id])
    current_user.saved_articles << @article
    render json: @article, notice: "Article saved for later."
  end
  def saved_articles
    @saved_articles = current_user.saved_articles
    render json: @saved_articles
  end
  def show
    @article = Article.find(params[:id])
    if current_user.can_view_article?
      render json: @article
    else
      # Redirect the user to a restricted content page or handle the restriction in your desired way
      redirect_to restricted_content_path, notice: "You have reached your daily article view limit."
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
    
