class AddCompanyFieldsToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :priority, :string, null: false, default: 'planning'
    add_column :tasks, :status, :string, null: false, default: 'open'
    add_reference :tasks, :department, foreign_key: true
    add_reference :tasks, :assignee, foreign_key: { to_table: :users }
    add_reference :tasks, :creator, foreign_key: { to_table: :users }
    
    add_index :tasks, :priority
    add_index :tasks, :status
    add_index :tasks, [:department_id, :status]
  end
end
