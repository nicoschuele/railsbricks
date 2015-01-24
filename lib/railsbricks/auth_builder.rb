require "fileutils"
require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"
require_relative "file_helpers"
require_relative "config_values"

module AuthBuilder

  def self.build_auth(app_dir, options)
    new_line(2)
    wputs "----> Generating authentication scheme ...", :info

    rbricks_dir = File.dirname(__FILE__)
    add_string = ""

    # Model
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/models/devise_email/user.rb", app_dir + "/app/models")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/models/devise_username/user.rb", app_dir + "/app/models")
    end
    wputs "--> User model created."

    # Migration
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/migrations/devise_email/20141010133701_devise_create_users.rb", app_dir + "/db/migrate")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/migrations/devise_username/20141010133701_devise_create_users.rb", app_dir + "/db/migrate")
    end
    wputs "--> Migration created."

    # Seeds
    FileUtils.rm(app_dir + "/db/seeds.rb")
    if options[:devise_config][:scheme] == "email"
      if options[:devise_config][:test_users]
        FileUtils.cp_r(rbricks_dir + "/assets/seeds/devise_email/seeds_test_users.rb", app_dir + "/db/seeds.rb")
      else
        FileUtils.cp_r(rbricks_dir + "/assets/seeds/devise_email/seeds_no_test_users.rb", app_dir + "/db/seeds.rb")
      end
    else
      if options[:devise_config][:test_users]
        FileUtils.cp_r(rbricks_dir + "/assets/seeds/devise_username/seeds_test_users.rb", app_dir + "/db/seeds.rb")
      else
        FileUtils.cp_r(rbricks_dir + "/assets/seeds/devise_username/seeds_no_test_users.rb", app_dir + "/db/seeds.rb")
      end
    end
    wputs "--> Seeds created."

    # Admin Controllers
    FileUtils.mkdir_p(app_dir + "/app/controllers/admin")
    FileUtils.cp_r(rbricks_dir + "/assets/controllers/admin/base_controller.rb", app_dir + "/app/controllers/admin/base_controller.rb")
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/controllers/admin/devise_email/users_controller.rb", app_dir + "/app/controllers/admin/users_controller.rb")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/controllers/admin/devise_username/users_controller.rb", app_dir + "/app/controllers/admin/users_controller.rb")
    end
    wputs "--> User admin controllers created."

    # Controllers
    FileUtils.cp_r(rbricks_dir + "/assets/controllers/pages_controller.rb", app_dir + "/app/controllers/pages_controller.rb")
    FileUtils.rm(app_dir + "/app/controllers/application_controller.rb")
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/controllers/devise_email/application_controller.rb", app_dir + "/app/controllers/application_controller.rb")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/controllers/devise_username/application_controller.rb", app_dir + "/app/controllers/application_controller.rb")
    end
    wputs "--> Controllers created."

    # Admin Views
    FileUtils.mkdir_p(app_dir + "/app/views/admin")
    FileUtils.mkdir_p(app_dir + "/app/views/admin/base")
    FileUtils.mkdir_p(app_dir + "/app/views/admin/users")
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/views/admin/base/devise_email/index.html.erb", app_dir + "/app/views/admin/base")
      FileUtils.cp_r(rbricks_dir + "/assets/views/admin/users/devise_email/index.html.erb", app_dir + "/app/views/admin/users")
      FileUtils.cp_r(rbricks_dir + "/assets/views/admin/users/devise_email/edit.html.erb", app_dir + "/app/views/admin/users")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/views/admin/base/devise_username/index.html.erb", app_dir + "/app/views/admin/base")
      FileUtils.cp_r(rbricks_dir + "/assets/views/admin/users/devise_username/index.html.erb", app_dir + "/app/views/admin/users")
      FileUtils.cp_r(rbricks_dir + "/assets/views/admin/users/devise_username/edit.html.erb", app_dir + "/app/views/admin/users")
    end
    wputs "--> Admin views created."

    # Devise views
    FileUtils.mkdir_p(app_dir + "/app/views/devise")
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/views/devise/devise_email/.", app_dir + "/app/views/devise")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/views/devise/devise_username/.", app_dir + "/app/views/devise")
    end
    wputs "--> Devise views created."

    # Links views
    FileUtils.rm(app_dir + "/app/views/layouts/_navigation_links.html.erb")
    FileUtils.cp_r(rbricks_dir + "/assets/views/layouts/_navigation_links.html.erb", app_dir + "/app/views/layouts")
    wputs "--> Navbar links created."

    # Protected page
    FileUtils.cp_r(rbricks_dir + "/assets/views/pages/inside.html.erb", app_dir + "/app/views/pages")
    wputs "--> Protected view created."

    # Devise initializer
    if options[:devise_config][:scheme] == "email"
      FileUtils.cp_r(rbricks_dir + "/assets/config/initializers/devise_email/devise.rb", app_dir + "/config/initializers")
    else
      FileUtils.cp_r(rbricks_dir + "/assets/config/initializers/devise_username/devise.rb", app_dir + "/config/initializers")
    end
    wputs "--> Devise initializer created."

    # Routes
    FileUtils.rm(app_dir + "/config/routes.rb")
    FileUtils.cp_r(rbricks_dir + "/assets/config/routes.rb", app_dir + "/config")
    wputs "--> Routes created."

    # Allow signup
    if options[:devise_config][:allow_signup]
      FileHelpers.replace_string(/BRICK_ALLOW_SIGNUP/, ':registerable,', app_dir + "/app/models/user.rb")
      FileHelpers.replace_string(/BRICK_ALLOW_SIGNUP_LINK/, '<li><%= link_to "Sign up", new_user_registration_path %></li>', app_dir + "/app/views/layouts/_navigation_links.html.erb")
      FileHelpers.replace_string(/BRICK_ALLOW_EDIT_LINK/, '<li><%= link_to "Edit your account", edit_user_registration_path %></li>', app_dir + "/app/views/layouts/_navigation_links.html.erb")
      FileHelpers.replace_string(/BRICK_ALLOW_SIGNUP_LINKS/, FileHelpers.get_file(:brick_allow_signup_links), app_dir + "/app/views/devise/shared/_links.erb")
    else
      FileHelpers.replace_string(/BRICK_ALLOW_SIGNUP/, '', app_dir + "/app/models/user.rb")
      FileHelpers.replace_string(/BRICK_ALLOW_SIGNUP_LINK/, '', app_dir + "/app/views/layouts/_navigation_links.html.erb")
      FileHelpers.replace_string(/BRICK_ALLOW_EDIT_LINK/, '', app_dir + "/app/views/layouts/_navigation_links.html.erb")
      FileHelpers.replace_string(/BRICK_ALLOW_SIGNUP_LINKS/, '', app_dir + "/app/views/devise/shared/_links.erb")
    end
    wputs "--> User registration options set."

    new_line
    wputs "----> Authentication scheme generated.", :info

  rescue
    Errors.display_error("Something went wrong and the authentication scheme couldn't be generated. Stopping app creation.", true)
    abort

  end

  def self.wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

  def self.new_line(lines=1)
    StringHelpers.new_line(lines)
  end

end
