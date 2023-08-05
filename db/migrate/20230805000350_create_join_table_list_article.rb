class CreateJoinTableListArticle < ActiveRecord::Migration[7.0]
  def change
    create_join_table :lists, :articles do |t|
      # t.index [:list_id, :article_id]
      # t.index [:article_id, :list_id]
    end
  end
end
