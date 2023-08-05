module ArticlesHelper
    def reading_time(article)
        words_per_minute = 100 # Adjust this value based on average reading speed
        word_count = article.content.split.size
        minutes = (word_count / words_per_minute).ceil
        minutes > 1 ? "#{minutes} minutes" : "1 minute"
      end
end
