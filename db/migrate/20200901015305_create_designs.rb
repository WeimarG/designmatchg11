class CreateDesigns < ActiveRecord::Migration[5.0]
  def change
    create_table :designs do |t|
      t.string :path_original_design, null: false
      t.string :path_modified_design, null: true
      t.integer :price, null: false

      t.belongs_to :project, foreign_key: true
      t.belongs_to :designer, foreign_key: true
      t.belongs_to :state, foreign_key: true

      t.timestamps
    end
  end
end