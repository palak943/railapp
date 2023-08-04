# app/models/user.rb
class User < ApplicationRecord

    has_secure_password

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    
    has_many :articles
    has_many :likes
    has_many :comments
    has_many :follows, dependent: :destroy
    has_many :authors, through: :follows

    def following?(author)
        authors.exists?(author.id)
    end

  end
  