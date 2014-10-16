# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
u = User.new(
    email: "admin@example.com",
    password: "1234",
    password_confirmation: "1234",
    admin: true
)
u.skip_confirmation!
u.save!


