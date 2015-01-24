class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content_md
      t.text :content_html
      t.boolean :draft, default: false
      t.integer :user_id

      # FriendlyId
      t.string :slug

      t.timestamps
    end
    add_index :posts, :user_id
  end
end
