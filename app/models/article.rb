class Article < ApplicationRecord
    belongs_to :user
    has_many :likes
    has_many :comments
    has_many :article_revisions, dependent: :destroy
    enum status: { draft: 0, published: 1, archived: 2 }

    def update(params)
        super
        create_article_revision if saved_changes?
      end
    
      private
    
      def create_article_revision
        article_revisions.create(title: title_before_last_save, content: content_before_last_save)
      end

end
