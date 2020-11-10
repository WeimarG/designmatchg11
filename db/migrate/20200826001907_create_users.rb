class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :company, :null => false
      t.string :email, :null => false
      t.string :password, :null => false
      t.string :password_confirmation, :null => false
      t.string :token, :null => true
      t.string :slug, :null => false

      t.index :email, unique: true

      t.timestamps
    end
  end
end
