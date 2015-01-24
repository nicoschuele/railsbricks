require "fileutils"
require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"
require_relative "file_helpers"
require_relative "gemfile_builder"
require_relative "style_builder"
require_relative "auth_builder"
require_relative "post_builder"
require_relative "config_helpers"

class AppGenerator

  attr_accessor :options

  def initialize(options)
    @options = options
    @app_dir = Dir.pwd + "/#{@options[:app_name]}"
    @rbricks_dir = File.dirname(__FILE__)
  end

  def generate_app
    # Drop creation if necessary
    if !@options[:generate]
      wputs "App creation aborted...", :error
      new_line
      abort
    end

    # updating necessary global gems
    update_essential_gems

    # install Rails
    install_rails

    # copy foundation app to directory
    create_foundation

    # ui
    StyleBuilder.build_style(@app_dir, @options)

    # database config
    config_db

    # environment variables
    config_env_var

    # authentication
    if @options[:devise]
      AuthBuilder.build_auth(@app_dir, @options)
    end

    # contact form
    add_contact_form

    # google analytics
    set_google_analytics

    # post resource
    if @options[:devise] && @options[:post_resources]
      PostBuilder.build_post(@app_dir, @options)
    elsif @options[:devise] && !@options[:post_resources]
      PostBuilder.clean(@app_dir)
    end

    # prod settings
    if @options[:production]
      set_production
    end

    # Set app name
    set_app_name

    # build Gemfile
    GemfileBuilder.build_gemfile(@app_dir, @options)

    # install gems
    bundle_install

    # create database
    create_database

    # save config
    ConfigHelpers.create_config(@app_dir, @options)

    # git
    set_git

    # Summary
    new_line(2)
    wputs "----> #{@options[:rails_app_name]} created successfully!", :help
    if @options[:devise]
      new_line
      wputs "Admin username: #{@options[:devise_config][:scheme] == 'email' ? 'admin@example.com' : 'admin' }", :info
      wputs "Admin password: 1234", :info
    end
    new_line
    wputs "Run 'rails server' within #{@options[:app_name]} to start it.", :help
    new_line

  end

  # Private/shortcut/alias methods

  private

  def update_essential_gems
    new_line
    wputs "----> Updating Rake & Bundler ... ", :info
    system "#{@options[:gem_command]} install rake --no-rdoc --no-ri"
    system "#{@options[:gem_command]} update rake"
    system "#{@options[:gem_command]} install bundler --no-rdoc --no-ri"
    system "#{@options[:gem_command]} update bundler"
    new_line
    wputs "----> Rake & Bundler updated to their latest versions.", :info
  rescue
    Errors.display_error("Required gems (rake & bundler) couldn't be updated properly. Stopping app creation.", true)
    abort
  end


  def install_rails
    new_line(2)
    wputs "----> Installing Rails #{@options[:rails_version]} ...", :info
    system "#{@options[:gem_command]} install rails -v #{@options[:rails_version]} --no-rdoc --no-ri"
    new_line
    wputs "----> Rails #{@options[:rails_version]} installed.", :info
  rescue
    Errors.display_error("Something went wrong and Rails #{@options[:rails_version]} couldn't be installed. Stopping app creation.", true)
    abort
  end

  def create_foundation
    FileUtils::mkdir_p @app_dir
    FileUtils.cp_r(@rbricks_dir + "/foundation/.", @app_dir)

  end

  def config_db
    new_line(2)
    wputs "----> Configuring database ...", :info

    if @options[:development_db] == "postgresql"
      FileUtils.cp_r(@rbricks_dir + "/assets/database/postgresql.yml", @app_dir + "/config/database.yml")
      FileHelpers.replace_string(/BRICK_DB_SERVER/, @options[:db_config][:server], @app_dir + "/config/database.yml")
      FileHelpers.replace_string(/BRICK_DB_PORT/, @options[:db_config][:port].to_s, @app_dir + "/config/database.yml")
      FileHelpers.replace_string(/BRICK_DB_NAME/, @options[:db_config][:name], @app_dir + "/config/database.yml")
      FileHelpers.replace_string(/BRICK_DB_USERNAME/, @options[:db_config][:username], @app_dir + "/config/database.yml")
      if @options[:db_config][:password].to_s == ''
        FileHelpers.replace_string(/BRICK_DB_PASSWORD/, '', @app_dir + "/config/database.yml")
      else
        FileHelpers.replace_string(/BRICK_DB_PASSWORD/, "password: #{@options[:db_config][:password]}", @app_dir + "/config/database.yml")
      end
    else
      FileUtils.cp_r(@rbricks_dir + "/assets/database/sqlite3.yml", @app_dir + "/config/database.yml")
    end

    new_line
    wputs "----> Database configuration set.", :info
  end


  def config_env_var
    new_line(2)
    wputs "----> Setting environment variables ...", :info
    FileUtils.cp_r(@rbricks_dir + "/assets/config/application.yml", @app_dir + "/config")
    FileHelpers.replace_string(/BRICK_VERSION/, @options[:railsbricks_version], @app_dir + "/config/application.yml")

    if @options[:email_settings]
      FileHelpers.replace_string(/BRICK_SENDER/, @options[:email_config][:sender], @app_dir + "/config/application.yml")
      FileHelpers.replace_string(/BRICK_SMTP_SERVER/, @options[:email_config][:smtp], @app_dir + "/config/application.yml")
      FileHelpers.replace_string(/BRICK_MAILER_DOMAIN/, @options[:email_config][:domain], @app_dir + "/config/application.yml")
      FileHelpers.replace_string(/BRICK_SMTP_PORT/, @options[:email_config][:port], @app_dir + "/config/application.yml")
      FileHelpers.replace_string(/BRICK_SMTP_USERNAME/, @options[:email_config][:username], @app_dir + "/config/application.yml")
      FileHelpers.replace_string(/BRICK_SMTP_PASSWORD/, @options[:email_config][:password], @app_dir + "/config/application.yml")
    end

    if @options[:production]
      FileHelpers.replace_string(/BRICK_DOMAIN/, @options[:production_settings][:url], @app_dir + "/config/application.yml")
    end

    new_line
    wputs "----> Environment variables set.", :info
  end

  def add_contact_form
    if @options[:contact_form]
      new_line(2)
      wputs "----> Creating contact form ...", :info

      # Views
      FileUtils.mkdir_p(@app_dir + "/app/views/contact_mailer")
      FileUtils.cp_r(@rbricks_dir + "/assets/views/pages/contact.html.erb", @app_dir + "/app/views/pages")
      FileUtils.cp_r(@rbricks_dir + "/assets/views/contact_mailer/contact_message.html.erb", @app_dir + "/app/views/contact_mailer")

      # Mailer
      FileUtils.cp_r(@rbricks_dir + "/assets/mailers/contact_mailer.rb", @app_dir + "/app/mailers")

      # Navbar link
      FileHelpers.replace_string(/BRICK_CONTACT/, "<li><%= link_to \"Contact\", contact_path %></li>", @app_dir + "/app/views/layouts/_navigation_links.html.erb")

      # Controller
      FileHelpers.replace_string(/BRICK_CONTACT_CONTROLLER/, FileHelpers.get_file(:brick_contact_controller), @app_dir + "/app/controllers/pages_controller.rb")

      # Routes
      FileHelpers.replace_string(/BRICK_CONTACT_ROUTES/, FileHelpers.get_file(:brick_contact_routes), @app_dir + "/config/routes.rb")

      new_line
      wputs "----> Contact form created.", :info
    else
      # Navbar link
      FileHelpers.replace_string(/BRICK_CONTACT/, '', @app_dir + "/app/views/layouts/_navigation_links.html.erb")
      # Controller
      FileHelpers.replace_string(/BRICK_CONTACT_CONTROLLER/, '', @app_dir + "/app/controllers/pages_controller.rb")
      # Routes
      FileHelpers.replace_string(/BRICK_CONTACT_ROUTES/, '', @app_dir + "/config/routes.rb")
    end
  end


  def set_google_analytics
    if @options[:google_analytics]
      new_line(2)
      wputs "----> Setting up Google Analytics ...", :info

      FileUtils.cp_r(@rbricks_dir + "/assets/javascripts/analytics.js.coffee", @app_dir + "/app/assets/javascripts")
      FileHelpers.replace_string(/BRICK_ANALYTICS/, FileHelpers.get_file(:brick_analytics), @app_dir + "/app/views/layouts/_footer.html.erb")
      FileHelpers.replace_string(/BRICK_ANALYTICS_ID/, @options[:google_tracking_id], @app_dir + "/app/views/layouts/_footer.html.erb")
      FileHelpers.replace_string(/BRICK_ANALYTICS_SCRIPT/, "\n//= require analytics", @app_dir + "/app/assets/javascripts/application.js")

      new_line
      wputs "----> Google Analytics set.", :info
    else
      FileHelpers.replace_string(/BRICK_ANALYTICS/, '', @app_dir + "/app/views/layouts/_footer.html.erb")
      FileHelpers.replace_string(/BRICK_ANALYTICS_SCRIPT/, '', @app_dir + "/app/assets/javascripts/application.js")
    end
  end

  def set_production
    new_line(2)
    wputs "----> Production settings ...", :info

    if @options[:production_settings][:unicorn]
      FileUtils.cp_r(@rbricks_dir + "/assets/procfile/Procfile", @app_dir)
      FileUtils.cp_r(@rbricks_dir + "/assets/config/unicorn.rb", @app_dir + "/config")
      wputs "--> Unicorn config created."
    end

    new_line
    wputs "----> Production settings updated.", :info
  end

  def set_app_name
    new_line(2)
    wputs "----> Setting app name ...", :info
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/routes.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/Rakefile")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/app/helpers/application_helper.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/app/views/layouts/application.html.erb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/application.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/environment.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/environments/development.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/environments/test.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/environments/production.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/initializers/secret_token.rb")
    FileHelpers.replace_string(/BRICK_APP_NAME/, @options[:rails_app_name], @app_dir + "/config/initializers/session_store.rb")
    new_line
    wputs "----> App name set.", :info
  end

  def bundle_install
    new_line(2)
    wputs "----> Installing gems into 'vendor/bundle/' ...", :info
    Dir.chdir "#{@app_dir}" do
      system "bundle install --without production --path vendor/bundle"
    end
    new_line
    wputs "----> Gems installed in 'vendor/bundle/'.", :info
  end

  def create_database
    new_line(2)
    wputs "----> Creating database ...", :info
    Dir.chdir "#{@app_dir}" do
      system "#{@options[:rake_command]} db:create:all"
      system "#{@options[:rake_command]} db:migrate"
      system "#{@options[:rake_command]} db:seed"
    end
    new_line
    wputs "----> Database created.", :info
  end

  def set_git
    # Always copy .gitignore
    FileUtils.cp_r(@rbricks_dir + "/assets/git/gitignore", @app_dir + "/.gitignore")

    if @options[:local_git]
      new_line(2)
      wputs "----> Setting up Git ...", :info
      Dir.chdir "#{@app_dir}" do
        system "git init"
        system "git add -A ."
        system "git commit -m 'initial commit (RailsBricks #{@options[:railsbricks_version]})'"

        if @options[:remote_git]
          system "git remote add origin #{@options[:git_url]}"
          system "git push origin master"
        end
      end

      new_line
      wputs "----> Git set up.", :info
    end
  end

  def wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

  def new_line(lines=1)
    StringHelpers.new_line(lines)
  end

end
