class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name_project, null: false
      t.string :description, null: false
      t.integer :e_value, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
