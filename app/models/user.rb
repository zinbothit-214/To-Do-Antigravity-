class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable
  belongs_to :department, optional: true
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id'
  has_many :created_tasks, class_name: 'Task', foreign_key: 'creator_id'
  
  enum role: { admin: 'admin', manager: 'manager', employee: 'employee' }
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
  
  scope :by_role, ->(role) { where(role: role) }
  scope :by_department, ->(department) { where(department: department) }
  scope :ordered, -> { order(:name) }
  
  def can_manage_department?(department)
    return true if admin?
    return false unless manager?
    self.department == department
  end
  
  def can_view_task?(task)
    return true if admin?
    return true if department == task.department
    assigned_tasks.include?(task) || created_tasks.include?(task)
  end
  
  def can_assign_task?(task)
    return true if admin?
    return false unless manager?
    can_manage_department?(task.department)
  end
  
  def department_users
    return User.all if admin?
    return department.users if manager?
    return [self] if employee?
    User.none
  end
end
