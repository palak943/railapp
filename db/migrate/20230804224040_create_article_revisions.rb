class CreateArticleRevisions < ActiveRecord::Migration[7.0]
  def change
    create_table :article_revisions do |t|
      t.references :article, foreign_key: true
      t.string :title
      t.string :category
      t.string :image
      t.text :text
      t.string :author
      t.timestamps
    end
  end
end
