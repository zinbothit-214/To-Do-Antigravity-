class CreateTaskActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :task_activities do |t|
      t.references :task, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action
      t.text :details

      t.timestamps
    end
  end
end
