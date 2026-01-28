class Department < ApplicationRecord
  has_many :users
  has_many :tasks
  
  validates :name, presence: true, uniqueness: true
  
  scope :ordered, -> { order(:name) }
  
  def user_count
    users.count
  end
  
  def task_count
    tasks.count
  end
  
  def incomplete_task_count
    tasks.where.not(status: 'completed').count
  end
end
