class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :post_id, default: 0
      t.string :title
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
