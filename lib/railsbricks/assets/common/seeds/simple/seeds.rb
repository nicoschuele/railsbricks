# Generated with RailsBricks
# Initial seed file to use with Simple User Model

# Temporary admin account
u = User.create!(
    username: "admin",
    email: "admin@example.com",
    password: "1234",
    password_confirmation: "1234",
    admin: true
)

# generate test users
(1..TESTUSERS).each do |i|
  u = User.create!(
      username: "user#{i}",
      email: "user#{i}@example.com",
      password: "1234",
      password_confirmation: "1234"
  )
  puts "#{i} users created ..." if (i % 5 == 0)
end
