class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :role, null: false, default: 'employee'
      t.references :department, foreign_key: true

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :role
  end
end
