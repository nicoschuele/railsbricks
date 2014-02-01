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

