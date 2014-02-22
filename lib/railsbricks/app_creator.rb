require "fileutils"
require_relative "string_helpers"
require_relative "errors"
require_relative "version"
require_relative "config_helpers"
require_relative "file_helpers"
class AppCreator

  def initialize(options={}, display_options = false)

    @options = options
    @RBRICK_DIR = File.dirname(__FILE__)
    @APP_DIR = Dir.pwd + "/#{@options[:app_path]}"

    # record at which time the app creation starts
    start_time = Time.now

    # show the user the app started getting generated
    new_line(2)
    wputs "----> Starting #{options[:app_name]} generation ...", :info

    if display_options
      new_line
      options.each { |k,v| wputs "#{k}: #{v}" }
    end

    # update required gems
    update_gems

    # install Rails 4.0.3
    rails_install

    # app creation
    create_app

    # update gemfile
    update_gemfile

    # update application with app name
    update_application

    # install gems
    bundle_install

    # application.yml
    configure_application_yml

    # configure test framework
    configure_tests

    # create seed data if needed
    generate_seed if @options[:authentication] != "none"

    # migrate the database
    db_migrate

    # save config options
    ConfigHelpers.create_config(@APP_DIR, options)

    # git it
    git_init if @options[:git_local]

    # record at which time the app got created
    end_time = Time.now


    # show the user the app finished getting generated
    new_line(2)
    wputs "----> #{options[:app_name]} generated in #{generation_time(start_time,end_time)}.", :info

    if options[:authentication] != "none"
      new_line
      wputs "***************************"
      wputs "Your default admin account:", :info
      new_line
      wputs "Username: admin"
      wputs "Password: 1234"
      wputs "***************************"
    end

    new_line
    wputs "RailsBricks v#{Version.current}"
    wputs "Happy coding! - http://www.railsbricks.net", :info
    new_line

  end



  private

  def update_gems
    new_line(2)
    wputs "----> Updating Rake & Bundler ... "
    new_line
    puts `#{@options[:gem_command]} install rake --no-rdoc --no-ri`
    puts `#{@options[:gem_command]} update rake`
    puts `#{@options[:gem_command]} install bundler --no-rdoc --no-ri`
    puts `#{@options[:gem_command]} update bundler`
    new_line
    wputs "----> Rake & Bundler updated to the latest version."

  rescue
    Errors.display_error("Required gems (rake & bundler) couldn't be updated properly. Stopping app creation.", true)
    abort

  end

  def rails_install
    new_line(2)
    wputs "----> Installing Rails 4.0.3 ..."
    new_line
    puts `#{@options[:gem_command]} install rails -v 4.0.3 --no-rdoc --no-ri`
    new_line
    wputs "----> Rails 4.0.3 installed."

  rescue
    Errors.display_error("Something went wrong and Rails 4.0.3 couldn't be installed. Stopping app creation.", true)
    abort

  end


  def create_app
    FileUtils::mkdir_p @APP_DIR

    # copy selected brick
    if @options[:authentication] == "none" && @options[:ui] == "reset"
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/none-reset/rbricksgen/.", @APP_DIR)
    elsif @options[:authentication] == "none" && @options[:ui] == "bootstrap3"
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/none-bootstrap/rbricksgen/.", @APP_DIR)
    elsif @options[:authentication] == "simple" && @options[:ui] == "reset"
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/simple-reset/rbricksgen/.", @APP_DIR)
    elsif @options[:authentication] == "simple" && @options[:ui] == "bootstrap3"
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/simple-bootstrap/rbricksgen/.", @APP_DIR)
    elsif @options[:authentication] == "devise" && @options[:ui] == "reset"
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/devise-reset/rbricksgen/.", @APP_DIR)
    elsif @options[:authentication] == "devise" && @options[:ui] == "bootstrap3"
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/devise-bootstrap/rbricksgen/.", @APP_DIR)
    else
      FileUtils.cp_r(@RBRICK_DIR + "/assets/bricks/none-reset/rbricksgen/.", @APP_DIR)
    end

  end

  def update_gemfile
    new_line(2)
    wputs "----> Creating Gemfile ..."

    FileHelpers.replace_string(/RUBYVERSION/,@options[:ruby_version],@APP_DIR + "/Gemfile")

    if @options[:hosting] == "heroku"
      new_line
      wputs "---> Adding Heroku gems ..."
      heroku_settings = File.read(@RBRICK_DIR + "/assets/common/gemfile/Heroku")
      FileHelpers.add_to_file(@APP_DIR + "/Gemfile", heroku_settings)
      wputs "---> Heroku gems added."
    end

    if @options[:authentication] == "devise"
      new_line
      wputs "---> Adding Devise gem ..."
      devise_gemfile = File.read(@RBRICK_DIR + "/assets/common/gemfile/Devise")
      FileHelpers.add_to_file(@APP_DIR + "/Gemfile", devise_gemfile)
      wputs "---> Devise gem added."
    end

    if @options[:ui] == "bootstrap3"
      new_line
      wputs "---> Adding Bootstrap 3 gems ..."
      bootstrap_gemfile = File.read(@RBRICK_DIR + "/assets/common/gemfile/Bootstrap")
      FileHelpers.add_to_file(@APP_DIR + "/Gemfile", bootstrap_gemfile)
      wputs "---> Bootstrap 3 gems added"
    end

    if @options[:test_framework] == "rspec"
      new_line
      wputs "---> Adding RSpec + Capybara gems ..."
      rspec_gemfile = File.read(@RBRICK_DIR + "/assets/common/gemfile/RSpec")
      FileHelpers.add_to_file(@APP_DIR + "/Gemfile", rspec_gemfile)
      wputs "---> RSpec + Capybara gems added."
    end

    new_line
    wputs "----> Gemfile created."
  end

  def bundle_install
    new_line(2)
    wputs "----> Installing gems into 'vendor/bundle/' ..."
    wputs "* THIS CAN TAKE A FEW MINUTES, PLEASE WAIT ... *", :info
    new_line
    Dir.chdir "#{@APP_DIR}" do
      puts `bundle install --without production --path vendor/bundle`
    end
    new_line
    wputs "----> Gems installed in 'vendor/bundle/'."
  end

  def configure_tests
    new_line(2)
    wputs "----> Configuring Test framework ..."
    Dir.chdir "#{@APP_DIR}" do

      if @options[:test_framework] == "none"
        FileUtils.rm_rf("test")
        FileHelpers.replace_string("# RAILSBRICKS_TEST_FRAMEWORK","config.generators.test_framework false", "config/application.rb")
      elsif @options[:test_framework] == "rspec"
        FileUtils.rm_rf("test")
        FileHelpers.replace_string("# RAILSBRICKS_TEST_FRAMEWORK","config.generators.test_framework false", "config/application.rb")
        new_line
        wputs "---> RSpec ..."
        puts `rails _4.0.3_ generate rspec:install`
        wputs "---> RSpec set."
      else
        wputs "---> Nothing to do.", :info
      end

    end
    new_line
    wputs "----> Test framework configured."
  end

  def update_application
    new_line(2)
    wputs "----> Updating #{@options[:app_name]} ..."
    new_line

    # Rakefile
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/Rakefile")

    # Helper
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/app/helpers/application_helper.rb")

    # application.html.erb
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/app/views/layouts/application.html.erb")

    # application.rb
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/application.rb")

    # environment.rb
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/environment.rb")

    # routes.rb
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/routes.rb")

    # environments
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/environments/development.rb")
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/environments/test.rb")
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/environments/production.rb")

    # secret_token.rb
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/initializers/secret_token.rb")

    # session_store.rb
    FileHelpers.replace_string(/Rbricksgen/, @options[:app_name], @APP_DIR + "/config/initializers/session_store.rb")

    new_line
    wputs "----> #{@options[:app_name]} updated."
  end



  def configure_application_yml
    new_line(2)
    wputs "----> Setting ENV variables in 'application.yml' ..."

    File.open(@APP_DIR + "/config/application.yml", "w") do |f|
      f.puts "# Generated by RailsBricks"
      f.puts "# ENVIRONMENT VARIABLES"
      f.puts "DOMAIN: \"#{@options[:domain_name]}\""
      f.puts "SENDER_EMAIL: \"#{@options[:email_sender]}\""
      f.puts "MAILER_DOMAIN: \"#{@options[:email_domain]}\""
      f.puts "SMTP_SERVER: \"#{@options[:smtp_server]}\""
      f.puts "SMTP_PORT: #{@options[:smtp_port]}"
      f.puts "SMTP_USER: \"#{@options[:smtp_username]}\""
      f.puts "SMTP_PWD: \"#{@options[:smtp_password]}\""
    end
    new_line
    wputs "----> ENV variables set in 'application.yml'."

  end

  def generate_seed
    new_line(2)
    wputs "----> Generating seed data ..."
    new_line
    if @options[:authentication] == "simple"
      if @options[:test_users] != nil
        FileHelpers.replace_string(/TESTUSERS/,@options[:test_users].to_s,@RBRICK_DIR + "/assets/common/seeds/simple/seeds.rb", @APP_DIR + "/db/seeds.rb")
      else
        FileUtils.cp(@RBRICK_DIR + "/assets/common/seeds/simple/seeds-no-test.rb", @APP_DIR + "/db/seeds.rb")
      end

    elsif @options[:authentication] == "devise"
      if @options[:test_users] != nil
        FileHelpers.replace_string(/TESTUSERS/,@options[:test_users].to_s,@RBRICK_DIR + "/assets/common/seeds/devise/seeds.rb", @APP_DIR + "/db/seeds.rb")
      else
        FileUtils.cp(@RBRICK_DIR + "/assets/common/seeds/devise/seeds-no-test.rb", @APP_DIR + "/db/seeds.rb")
      end

    else
      wputs "No authentication selected, nothing to do."
    end

    new_line
    wputs "----> Seed data generated."

  end

  def db_migrate
    new_line(2)
    wputs "----> Creating the database ..."

    Dir.chdir "#{@APP_DIR}" do
      puts `#{@options[:rake_command]} db:create:all`
      puts `#{@options[:rake_command]} db:migrate`

      new_line
      wputs "---> Seeding the database. It can take a few minutes if you have many test users ...", :info
      puts `#{@options[:rake_command]} db:seed`
      new_line

      wputs "---> Database seeded.", :info

    end

    new_line
    wputs "----> Database created."

  end

  def git_init
    Dir.chdir "#{@APP_DIR}" do
      new_line(2)
      wputs "----> Setting your local Git repository ..."

      new_line
      puts `git init`
      puts `git add -A .`
      puts `git commit -m "initial commit (generated with RailsBricks v#{Version.current})"`

      new_line
      wputs "----> Local Git repository set."

      if @options[:git_remote]
        new_line(2)
        wputs "----> Setting your remote Git repository ..."

        new_line
        puts `git remote add origin #{@options[:git_remote_url]}`
        puts `git push origin master`

        new_line
        wputs "----> Remote Git repository set."

      end
    end

  end

  # calculate time
  def generation_time(start_time, end_time)
    seconds = (start_time - end_time).to_i.abs

    minutes = seconds / 60
    seconds -= minutes * 60

    minute_word = minutes == 1 ? "minute" : "minutes"
    second_word = seconds == 1 ? "second" : "seconds"

    "#{minutes} #{minute_word} and #{seconds} #{second_word}"
  end

  # string helpers wrappers
  def new_line(lines=1)
    StringHelpers.new_line(lines)
  end

  def hputs(text)
    StringHelpers.hputs(text)
  end

  def wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

end