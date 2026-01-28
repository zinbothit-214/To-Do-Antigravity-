require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  setup do
    @user = users(:admin)
  end

  test "should be valid with a title and creator" do
    task = Task.new(title: "Do something", creator: @user)
    assert task.valid?
  end

  test "should be invalid without a title" do
    task = Task.new(title: "", creator: @user)
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "should be invalid without a creator" do
    task = Task.new(title: "Do something")
    assert_not task.valid?
    assert_includes task.errors[:creator], "can't be blank"
  end

  test "incomplete scope returns only incomplete tasks" do
    Task.create!(title: "Incomplete", status: :open, creator: @user)
    Task.create!(title: "Complete", status: :completed, creator: @user)
    
    # fixture 'one' has status: open
    assert_includes Task.incomplete, tasks(:one) 
    assert_not_includes Task.incomplete, Task.find_by(status: :completed, title: "Complete")
  end

  test "complete scope returns only completed tasks" do
    Task.create!(title: "Incomplete", status: :open, creator: @user)
    Task.create!(title: "Complete", status: :completed, creator: @user)
    
    assert_includes Task.complete, Task.find_by(status: :completed, title: "Complete")
    assert_not_includes Task.complete, tasks(:one)
  end
end
