class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :assign]
  before_action :authorize_task!, only: [:show, :edit]
  before_action :authorize_task_update!, only: [:update]
  before_action :authorize_task_assignment!, only: [:assign]

  def index
    @tasks = accessible_tasks.includes(:assignee, :creator, :department)
    @departments = accessible_departments.ordered
    @task = Task.new(department: @current_department)
    
    # Apply filters
    @tasks = @tasks.by_department(params[:department_id]) if params[:department_id].present?
    @tasks = @tasks.by_priority(params[:priority]) if params[:priority].present?
    @tasks = @tasks.by_status(params[:status]) if params[:status].present?
  end

  def dashboard
    @user_stats = current_user.role
    case current_user.role
    when 'admin'
      @total_tasks = Task.count
      @open_tasks = Task.open.count
      @urgent_tasks = Task.urgent.count
      @departments = Department.includes(:users, :tasks)
    when 'manager'
      @dept_tasks = Task.by_department(current_user.department)
      @open_tasks = @dept_tasks.open.count
      @urgent_tasks = @dept_tasks.urgent.count
      @team_members = current_user.department.users.includes(:assigned_tasks)
    when 'employee'
      @my_tasks = Task.for_user(current_user)
      @open_tasks = @my_tasks.open.count
      @urgent_tasks = @my_tasks.urgent.count
    end
    
    @recent_tasks = accessible_tasks.ordered.limit(10)
  end

  def my_tasks
    @tasks = Task.for_user(current_user).ordered.includes(:assignee, :creator, :department)
    @task = Task.new(department: @current_department)
    render :index
  end

  def show
    @activities = @task.task_activities.order(created_at: :desc).limit(20)
  end

  def new
    @task = Task.new(department: @current_department)
    @departments = accessible_departments.ordered
  end

  def edit
    authorize_task_update!(@task)
    @departments = accessible_departments.ordered
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user
    @task.department ||= @current_department
    
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      @tasks = accessible_tasks.ordered
      @departments = accessible_departments.ordered
      render :index
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { 
          @departments = accessible_departments.ordered
          render :edit 
        }
        format.js
      end
    end
  end

  def assign
    assignee = User.find(params[:assignee_id])
    if @task.assign?(current_user)
      @task.update(assignee: assignee, status: 'in_progress')
      redirect_to @task, notice: "Task assigned to #{assignee.name}."
    else
      redirect_to @task, alert: 'Access denied. You cannot assign this task.'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully deleted.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    permitted = [:title, :description, :priority, :status, :department_id, :assignee_id]
    params.require(:task).permit(*permitted)
  end
end
