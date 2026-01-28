require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
    sign_in @user
    @task = tasks(:one)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should show task" do
    get task_url(@task)
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post tasks_url, params: { task: { title: 'New Task', description: 'Test description', priority: 'urgent', status: 'open' } }
    end
    assert_redirected_to task_url(Task.last)
  end

  test "should update task" do
    patch task_url(@task), params: { task: { title: 'Updated Title', status: 'completed' } }
    assert_redirected_to task_url(@task)
    @task.reload
    assert_equal 'Updated Title', @task.title
    assert_equal 'completed', @task.status
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end
    assert_redirected_to tasks_url
  end

  test "should update task via ajax" do
    patch task_url(@task), params: { task: { status: 'completed' } }, xhr: true
    assert_response :success
    @task.reload
    assert_equal 'completed', @task.status
  end

  test "should get dashboard" do
    get dashboard_url
    assert_response :success
  end

  test "should get my_tasks" do
    get my_tasks_url
    assert_response :success
  end

  test "should assign task" do
    patch assign_task_url(@task), params: { assignee_id: users(:employee).id }
    assert_redirected_to task_url(@task)
    @task.reload
    assert_equal users(:employee).id, @task.assignee_id
    assert_equal 'in_progress', @task.status
  end

  test "should keep planning tasks at top based on priority asc" do
    # priority enums: planning (0), urgent (4)
    # ordered scope: order(priority: :asc, created_at: :desc)
    # planning should come before urgent
    get tasks_url
    assert_select '.tasks-list .task:first-child .task-priority', text: /Planning/
  end
end
