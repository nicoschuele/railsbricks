class User < ActiveRecord::Base
  # Use friendly_id on Users
  extend FriendlyId
  friendly_id :friendify, use: :slugged
  
  # necessary to override friendly_id reserved words
  def friendify
    if username.downcase == "admin"
      "user-#{username}"
    else
      "#{username}"
    end
  end
  
  # Use a secure password
  has_secure_password
  
  # Basic validations
  validates :username,:email, presence: true
  validates :username, length: { in: 4..10 }
  validates :username, uniqueness: { case_sensitive: false }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 4 }, on: :create
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create
  validates_format_of :username, with: /\A[a-zA-Z0-9]*\z/, on: :create, message: "can only contain letters and digits"
  
end