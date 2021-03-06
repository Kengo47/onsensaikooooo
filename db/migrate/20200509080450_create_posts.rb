class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, foreign_key: true
      t.string :picture

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
