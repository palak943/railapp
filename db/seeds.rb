# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

# db/seeds.rb

# Create users
user1 = User.create(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123'
)

user2 = User.create(
  name: 'Jane Smith',
  email: 'jane@example.com',
  password: 'password456'
)

# Create 10 articles
10.times do |n|
  Article.create(
    title: "Article #{n + 1}",
    category: ['Technology', 'Science', 'Business'].sample,
    image: "https://example.com/image#{n + 1}.jpg",
    text: "Lorem ipsum dolor sit amet #{n + 1}",
    author: n.even? ? 'John Doe' : 'Jane Smith',
    user_id: n.even? ? user1.id : user2.id,
    status: 'published'
  )
end

# Create article revisions for each article
Article.all.each do |article|
  ArticleRevision.create(
    article_id: article.id,
    title: "#{article.title} - Revised",
    category: article.category,
    image: "https://example.com/image#{article.id}_v2.jpg",
    text: "Updated content for #{article.title}",
    author: article.author
  )
end

# Create comments and likes for each article
Article.all.each do |article|
  3.times do
    Comment.create(
      body: 'Great article!',
      user_id: [user1.id, user2.id].sample,
      article_id: article.id
    )
  end

  Like.create(
    user_id: [user1.id, user2.id].sample,
    article_id: article.id
  )
end

# Create lists for each user
user1_list = List.create(name: 'My Reading List', user_id: user1.id)
user2_list = List.create(name: 'Favorite Articles', user_id: user2.id)

# Add articles to lists
user1_list.articles << Article.first(5)
user2_list.articles << Article.last(5)
