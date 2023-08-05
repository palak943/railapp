class AddPostLimitToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :post_limit, :integer, default: 1
  end
end
