# This file should contain all the record creation needed to seed the database with its default values.

puts "Creating departments..."
# Create default departments
Department.find_or_create_by!(name: 'Engineering') do |dept|
  dept.description = 'Software development and technical operations'
end

Department.find_or_create_by!(name: 'Marketing') do |dept|
  dept.description = 'Marketing campaigns and brand management'
end

Department.find_or_create_by!(name: 'Human Resources') do |dept|
  dept.description = 'Employee management and company culture'
end

Department.find_or_create_by!(name: 'Sales') do |dept|
  dept.description = 'Customer relations and revenue generation'
end

puts "Creating users..."
# Create admin user
admin = User.find_or_create_by!(email: 'admin@company.com') do |user|
  user.name = 'System Admin'
  user.password = 'password123'
  user.role = 'admin'
end

puts "Creating manager users..."
# Create manager users
hr_manager = User.find_or_create_by!(email: 'hr@company.com') do |user|
  user.name = 'HR Manager'
  user.password = 'password123'
  user.role = 'manager'
  user.department = Department.find_by(name: 'Human Resources')
end

eng_manager = User.find_or_create_by!(email: 'eng@company.com') do |user|
  user.name = 'Engineering Manager'
  user.password = 'password123'
  user.role = 'manager'
  user.department = Department.find_by(name: 'Engineering')
end

puts "Creating employee users..."
# Create employee users
john_employee = User.find_or_create_by!(email: 'john@company.com') do |user|
  user.name = 'John Doe'
  user.password = 'password123'
  user.role = 'employee'
  user.department = Department.find_by(name: 'Engineering')
end

jane_employee = User.find_or_create_by!(email: 'jane@company.com') do |user|
  user.name = 'Jane Smith'
  user.password = 'password123'
  user.role = 'employee'
  user.department = Department.find_by(name: 'Marketing')
end

bob_employee = User.find_or_create_by!(email: 'bob@company.com') do |user|
  user.name = 'Bob Johnson'
  user.password = 'password123'
  user.role = 'employee'
  user.department = Department.find_by(name: 'Sales')
end

puts "Creating tasks..."
# Get department references
eng_dept = Department.find_by(name: 'Engineering')
hr_dept = Department.find_by(name: 'Human Resources')
marketing_dept = Department.find_by(name: 'Marketing')
sales_dept = Department.find_by(name: 'Sales')

# Create sample tasks
Task.find_or_create_by!(title: 'Setup development environment') do |task|
  task.description = 'Configure the development server and database connections'
  task.priority = 'planning'
  task.status = 'open'
  task.department = eng_dept
  task.creator = eng_manager
  task.assignee = john_employee
end

Task.find_or_create_by!(title: 'Review Q1 marketing strategy') do |task|
  task.description = 'Analyze marketing campaign performance and plan Q2 initiatives'
  task.priority = 'review'
  task.status = 'in_progress'
  task.department = marketing_dept
  task.creator = eng_manager
  task.assignee = jane_employee
end

Task.find_or_create_by!(title: 'Update employee handbook') do |task|
  task.description = 'Review and update company policies for 2024'
  task.priority = 'approval'
  task.status = 'open'
  task.department = hr_dept
  task.creator = hr_manager
end

Task.find_or_create_by!(title: 'Client meeting preparation') do |task|
  task.description = 'Prepare presentation materials and agenda for upcoming client meeting'
  task.priority = 'urgent'
  task.status = 'in_progress'
  task.department = sales_dept
  task.creator = eng_manager
  task.assignee = bob_employee
end

Task.find_or_create_by!(title: 'Database optimization') do |task|
  task.description = 'Optimize database queries and improve performance'
  task.priority = 'execution'
  task.status = 'open'
  task.department = eng_dept
  task.creator = eng_manager
end

puts "Seed data created successfully!"
puts "\nLogin credentials:"
puts "Admin: admin@company.com / password123"
puts "HR Manager: hr@company.com / password123"
puts "Engineering Manager: eng@company.com / password123"
puts "Employees:"
puts "- john@company.com / password123"
puts "- jane@company.com / password123"
puts "- bob@company.com / password123"