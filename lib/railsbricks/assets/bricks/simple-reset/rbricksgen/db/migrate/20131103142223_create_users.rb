class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.boolean :admin, default: false
      t.string :slug

      t.timestamps
    end
    add_index :users, :slug, unique: true
  end
end
