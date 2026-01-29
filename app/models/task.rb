class Task < ApplicationRecord
  belongs_to :department, optional: true
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User'
  
  has_many :task_activities, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  enum priority: { 
    planning: 'planning', 
    review: 'review', 
    approval: 'approval', 
    execution: 'execution', 
    urgent: 'urgent' 
  }
  
  enum status: { 
    open: 'open', 
    in_progress: 'in_progress', 
    completed: 'completed', 
    blocked: 'blocked' 
  }
  
  validates :title, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validates :creator, presence: true
  
  scope :ordered, -> { order(priority: :asc, created_at: :desc) }
  scope :by_priority, ->(priority) { where(priority: priority) if priority.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_department, ->(department) { where(department: department) if department.present? }
  scope :by_assignee, ->(assignee) { where(assignee: assignee) if assignee.present? }
  scope :incomplete, -> { where.not(status: :completed) }
  scope :complete, -> { where(status: :completed) }
  scope :urgent, -> { where(priority: :urgent) }
  scope :for_user, ->(user) { 
    tasks = where(creator: user)
    tasks = tasks.or(where(assignee: user))
    tasks
  }
  
  def self.incomplete
    where.not(status: :completed)
  end
  
  def self.complete
    where(status: :completed)
  end
  
  def priority_icon
    case priority
    when 'planning'
      '📋'
    when 'review'
      '🔍'
    when 'approval'
      '⏳'
    when 'execution'
      '🚀'
    when 'urgent'
      '🔴'
    end
  end
  
  def priority_color
    case priority
    when 'planning'
      '#007bff'
    when 'review'
      '#ffc107'
    when 'approval'
      '#fd7e14'
    when 'execution'
      '#28a745'
    when 'urgent'
      '#dc3545'
    end
  end
  
  def status_badge
    case status
    when 'open'
      { text: 'Open', color: '#6c757d' }
    when 'in_progress'
      { text: 'In Progress', color: '#007bff' }
    when 'completed'
      { text: 'Completed', color: '#28a745' }
    when 'blocked'
      { text: 'Blocked', color: '#dc3545' }
    end
  end
  
  def assign?(user)
    return true if user.admin?
    return false unless user.manager?
    user.can_manage_department?(department)
  end
  
  def updateable_by?(user)
    return true if user.admin?
    return true if creator == user
    return true if assignee == user && status.in?(['open', 'in_progress'])
    false
  end
end
