# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    has_secure_password

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :post_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
    
    has_many :articles
    has_many :likes
    has_many :comments
    has_many :follows, dependent: :destroy
    has_many :authors, through: :follows

    def following?(author)
        authors.exists?(author.id)
    end
    def can_view_article?
      return true if post_limit == 0
  
      articles_today = articles.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
      articles_today < post_limit
    end
  
    has_many :saved_articles, through: :saved_articles_users, source: :article
  has_many :saved_articles_users, foreign_key: :user_id, class_name: 'SavedArticle'
  end
  