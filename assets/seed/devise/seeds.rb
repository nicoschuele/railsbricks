# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
u = User.new(
  username: "admin",
  email: "admin@example.com",
  password: "1234",
  password_confirmation: "1234",
  admin: true
)
u.skip_confirmation!
u.save!

# Prompt for test data
STDOUT.puts
STDOUT.print "Do you want to seed test data?(y/n):"
result = STDIN.gets.chomp

if result == "y"
  
  # Test user accounts
  STDOUT.puts
  STDOUT.print "How many test users?:"
  users_amount = STDIN.gets.chomp.to_i
  (1..users_amount).each do |i|
    u = User.new(
      username: "user#{i}",
      email: "user#{i}@example.com",
      password: "1234",
      password_confirmation: "1234"
    )
    u.skip_confirmation!
    u.save!
    
    puts "#{i} test users created..." if (i % 10 == 0)
    
  end
  
end
