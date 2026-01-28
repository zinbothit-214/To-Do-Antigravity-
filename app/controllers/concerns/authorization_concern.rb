module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    helper_method :accessible_departments, :accessible_tasks, :accessible_users if respond_to?(:helper_method)
  end

  protected

  def require_admin!
    redirect_to root_path, alert: 'Access denied. Admin access required.' unless current_user&.admin?
  end

  def require_manager!
    redirect_to root_path, alert: 'Access denied. Manager access required.' unless current_user&.manager? || current_user&.admin?
  end

  def accessible_departments
    return Department.all if current_user&.admin?
    return [current_user.department].compact if current_user&.department
    Department.none
  end

  def accessible_tasks
    return Task.all if current_user&.admin?
    return Task.by_department(current_user.department) if current_user&.manager?
    return Task.for_user(current_user) if current_user&.employee?
    Task.none
  end

  def accessible_users
    return User.all if current_user&.admin?
    return current_user.department&.users || User.none if current_user&.manager?
    return [current_user] if current_user&.employee?
    User.none
  end

  def authorize_task!
    # Uses @task set by set_task before_action
    return if current_user&.can_view_task?(@task)
    redirect_to tasks_path, alert: 'Access denied. You cannot view this task.'
  end

  def authorize_task_update!
    # Uses @task set by set_task before_action
    return if @task.updateable_by?(current_user)
    redirect_to task_path(@task), alert: 'Access denied. You cannot update this task.'
  end

  def authorize_task_assignment!
    # Uses @task set by set_task before_action
    return if @task.assign?(current_user)
    redirect_to task_path(@task), alert: 'Access denied. You cannot assign this task.'
  end
end