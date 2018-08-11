class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.belongs_to :user
      t.text :title
      t.integer :project_kind
      
      t.timestamps
    end
  end
end
