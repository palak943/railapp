class CreateSavedArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_articles do |t|
      t.references :user, foreign_key: true
      t.references :article, foreign_key: true
      t.timestamps
    end
  end
end
