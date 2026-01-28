class DepartmentsController < ApplicationController
  before_action :require_admin!, except: [:index, :show]
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :authorize_department!, only: [:show, :edit, :update, :destroy]

  def index
    @departments = accessible_departments.ordered
    @department = Department.new
  end

  def show
    @tasks = @department.tasks.ordered.includes(:assignee, :creator)
    @users = @department.users.ordered
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to @department, notice: 'Department was successfully created.'
    else
      @departments = accessible_departments.ordered
      render :index
    end
  end

  def edit
  end

  def update
    if @department.update(department_params)
      redirect_to @department, notice: 'Department was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @department.destroy
    redirect_to departments_path, notice: 'Department was successfully deleted.'
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def authorize_department!
    return if current_user&.admin?
    return if current_user&.can_manage_department?(@department)
    redirect_to departments_path, alert: 'Access denied.'
  end

  def department_params
    params.require(:department).permit(:name, :description)
  end
end
