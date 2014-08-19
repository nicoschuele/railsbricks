require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"

class Menu

  # the Wizard triggered when creating a new RailsBricks app
  class WizardMenu < Menu

    def initialize(verbose = true)
      @verbose = verbose
    end

    def display_menu
      options = {}

      welcome


      # INTRODUCTION
      new_line(2)
      wputs "1. Intro"
      wputs "--------"
      if @verbose
        wputs "Hi. I'm the RailsBricks wizard. Let's spend a little while together to set up your awesome Rails application. If you think that I talk too much, I won't be offended. You can make me shut up by creating a new app with the command:", :info
        new_line
        hputs " rbricks -n --shut-up"
      end

      # create new app
      new_line
      wputs "- Create a new Rails app?"
      print "Your choice (y/n): "
      choice = STDIN.gets.chomp.downcase.strip
      return unless choice == "y"


      # ENVIRONMENT
      new_line(2)
      wputs "2. Your Environment"
      wputs "-------------------"
      if @verbose
        wputs "First, I will need some information about your environment.", :info
      end

      # ruby version
      new_line
      wputs "- Which version of Ruby do you want to use?"
      hputs "1. 1.9.3"
      hputs "2. 2.0.0"
      hputs "3. 2.1.1"
      hputs "4. 2.1.2 (default)"
      print "Your choice (1-4): "
      choice = STDIN.gets.chomp.strip
      if choice == "1"
        options[:ruby_version] = "1.9.3"
      elsif choice == "2"
        options[:ruby_version] = "2.0.0"
      elsif choice == "3"
        options[:ruby_version] = "2.1.1"
      else
        options[:ruby_version] = "2.1.2"
      end

      # gem install command
      new_line
      wputs "- How do you usually run your 'gem install' command?"
      hputs "1. gem install name_of_gem (default)"
      hputs "2. sudo gem install name_of_gem"
      hputs "3. I don't know"
      print "Your choice (1-3): "
      choice = STDIN.gets.chomp.strip
      if choice == "2"
        options[:gem_command] = "sudo gem"
      else
        options[:gem_command] = "gem"
      end

      # rake command
      new_line
      wputs "- How do you usually run rake tasks?"
      hputs "1. rake some_task (default)"
      hputs "2. bundle exec rake some_task"
      hputs "3. I don't know that"
      print "Your choice (1-3): "
      choice = STDIN.gets.chomp.strip
      if choice == "2"
        options[:rake_command] = "bundle exec rake"
      else
        options[:rake_command] = "rake"
      end

      # ruby version manager
      new_line
      wputs "- Do you use RVM, rbenv or any other Ruby version manager?"
      hputs "1. RVM"
      hputs "2. rbenv"
      hputs "3. other"
      hputs "4. none (default)"
      print "Your choice (1-4): "
      choice = STDIN.gets.chomp.strip
      case choice
        when "1"
          options[:ruby_version_manager] = "rvm"
        when "2"
          options[:ruby_version_manager] = "rbenv"
        when "3"
          options[:ruby_version_manager] = "other"
        else
          options[:ruby_version_manager] = "none"
      end


      # APPLICATION
      new_line(2)
      wputs "3. Your App"
      wputs "-----------"
      if @verbose
        wputs "Ok, I've got enough information about your environment for now.", :info
        new_line
        wputs "Let's talk about the app you want to create. I can tell you it will be a Rails 4.1.5 app and that the gem Rails 4.1.5 will be installed globally (in your main gem location, that is). So, if you already have other versions of Rails installed, don't forget to call your 'rails' command with the correct version, like 'rails _4.1.5_ server', for example.", :info
        new_line
        wputs "If you wonder, other gems will be isolated from your other ones and installed within 'vendor/bundle' inside your app.", :info
      end

      # app name
      new_line
      wputs "- What is the name of your app?"
      print "Enter app name: "
      choice = STDIN.gets.chomp.strip
      if choice.length < 1
        choice = "railsbricks_app"
      end
      options[:app_path] = StringHelpers.sanitize(choice)
      options[:app_name] = StringHelpers.convert_to_app_name(options[:app_path])


      # PRODUCTION ENVIRONMENT
      new_line(2)
      wputs "4. Your Production Environment"
      wputs "------------------------------"
      if @verbose
        wputs "I guess that at some point, your fantastic app is going to be available to everyone on the web. If you wish, we can set up some parameters together already like the domain name you'll use. Of course, you can modify them at a later stage.", :info
      end

      # configure prod?
      new_line
      wputs "- Do you want to configure production settings?"
      print "Your choice (y/n): "
      choice = STDIN.gets.chomp.downcase.strip
      set_prod = choice == "y"

      if set_prod
        options[:set_production] = true


        # hosting
        new_line
        wputs "- Where will your app be hosted?"
        hputs "1. Heroku (default)"
        hputs "2. Somewhere else"
        print "Your choice (1-2): "
        choice = STDIN.gets.chomp.strip
        if choice == "2"
          options[:hosting] = "other"
        else
          options[:hosting] = "heroku"
        end

        # domain name
        new_line
        wputs "- What will be its domain name?"
        wputs"(example: www.myawesomeapp.com, myawesomeapp.example.com, etc...)"
        print "Domain name (without http://): "
        choice = STDIN.gets.chomp.downcase.strip
        options[:domain_name] = choice


      else
        options[:set_production] = false
        options[:hosting] = nil
        options[:domain_name] = ""
      end


      # DATABASE
      new_line(2)
      wputs "5. Your Database"
      wputs "****************"
      if @verbose
        wputs "I need to know which database engine you will use. You can change these settings at a later stage.
", :info
      end

      # configure database
      new_line
      # TODO Implement database engine selection
      wputs "This version of RailsBricks uses SQLite in Development and Test. You will need to set your Production database manually if you don't use Heroku for hosting your app. This will change in a future version of RailsBricks."
      new_line
      print "Press Enter to continue: "
      STDIN.gets.chomp


      # AUTHENTICATION
      new_line(2)
      wputs "6. Your Authentication Model"
      wputs "****************************"
      if @verbose
        wputs "Your app will maybe have users. Maybe you even want users to be able to create an account on your app in which case I recommend you select Devise in the given options. If you'll only have a handful of users or even only one you'll manage yourself, I recommend that you use the Simple authentication.", :info
      end

      # TODO implement various User models

      # which authentication
      new_line
      wputs "- Which authentication model do you want to use?"
      hputs "1. Simple authentication (default)"
      hputs "2. Devise (login with email)"
      hputs "3. Devise (login with username)"
      hputs "4. No authentication"
      print "Your choice (1-4): "
      choice = STDIN.gets.chomp.strip
      case choice
        when "2"
          options[:authentication] = "devise-email"
        when "3"
          options[:authentication] = "devise-username"
        when "4"
          options[:authentication] = "none"
        else
          options[:authentication] = "simple"
      end

      # TODO give an option not to use :confirmable by default
      if options[:authentication] == "devise"
        options[:confirmable] = true
      else
        options[:confirmable] = false
      end
      #if options[:authentication] == "devise"
      #
      #  # confirmable
      #  wputs "- Do you want your users to confirm their e-mail address?"
      #  print "Your choice (y/n): "
      #  choice = STDIN.gets.chomp.downcase.strip
      #  options[:confirmable] = choice == "y"
      #
      #else
      #  options[:confirmable] = false
      #
      #end

      if options[:authentication][0..5] == "devise" || options[:authentication] == "simple"

        # test users
        new_line
        wputs "- Do you want to create test users?"
        hputs "1. Yes, create 5"
        hputs "2. Yes, create 50"
        hputs "3. Yes, create 250 (slow)"
        hputs "4. Yes, create 1000 (slower)"
        hputs "5. No, only create my Admin account (default)"
        print "Your choice (1-5): "
        choice = STDIN.gets.chomp.strip
        case choice
          when "1"
            options[:test_users] = 5
          when "2"
            options[:test_users] = 50
          when "3"
            options[:test_users] = 250
          when "4"
            options[:test_users] = 1000
          else
            options[:test_users] = nil
        end

      else
        options[:test_users] = nil

      end


      # EMAIL SETTINGS
      new_line(2)
      wputs "7. Your Email Settings"
      wputs "**********************"
      if @verbose
        wputs "If you want your app to be able to send emails, I need to get few information from you. Of course, you can change these settings manually later by editing 'config/application.yml'. If you are using the Devise authentication model, I strongly advise you to set these settings already so they'll be able to retrieve their forgotten password (silly users) or confirm their email address.", :info
      end

      # TODO implement different emails providers

      # set emailing?
      new_line
      wputs "- Configure email settings?"
      print "Your choice (y/n): "
      choice = STDIN.gets.chomp.downcase.strip
      options[:set_emails] = choice == "y"

      if options[:set_emails]

        # sender email
        new_line
        wputs "- Which is the email address to send your emails from?"
        wputs "(example: noreply@example.com)"
        print "Email address: "
        options[:email_sender] = STDIN.gets.chomp.downcase.strip

        # email domain
        new_line
        wputs "- Which is the domain name of your SMTP server?"
        wputs "(example: mydomain.com)"
        print "Domain name: "
        options[:email_domain] = STDIN.gets.chomp.downcase.strip

        # smtp server
        new_line
        wputs "- Your SMTP server address?"
        wputs "(example: smtp.mydomain.com, 192.54.23.127, etc...)"
        print "SMTP server: "
        options[:smtp_server] = STDIN.gets.chomp.downcase.strip

        # smtp port
        new_line
        wputs "- Your SMTP port number?"
        wputs "(example: 26)"
        print "SMTP port number: "
        options[:smtp_port] = STDIN.gets.chomp.strip.to_i

        # smtp username
        new_line
        wputs "- Your SMTP username?"
        print "SMTP username: "
        options[:smtp_username] = STDIN.gets.chomp.strip

        # smtp password
        new_line
        wputs "- Your SMTP password?"
        print "SMTP password: "
        options[:smtp_password] = STDIN.gets.chomp

      else
        options[:email_sender] = ""
        options[:email_domain] = ""
        options[:smtp_server] = ""
        options[:smtp_port] = 0
        options[:smtp_username] = ""
        options[:smtp_password]

      end


      # TEST FRAMEWORK
      new_line(2)
      wputs "8. Your Test Framework"
      wputs "**********************"
      if @verbose
        wputs "I won't tell you how important it is to test your app, to make it more robust, yadda yadda. So, I will let you choose one test framework. Of course, if testing is only for others but not you, you can opt to have no tests generated at all. Ever.", :info
      end

      # which framework
      new_line
      wputs "- Which test framework?"
      hputs "1. Built-in Rails test framework (default)"
      hputs "2. RSpec + Capybara"
      hputs "3. Don't generate tests"
      print "Your choice (1-3): "
      choice = STDIN.gets.chomp.strip
      case choice
        when "2"
          options[:test_framework] = "rspec"
        when "3"
          options[:test_framework] = "none"
        else
          options[:test_framework] = "default"
      end


      # UI
      new_line(2)
      wputs "9. Your User Interface"
      wputs "**********************"
      if @verbose
        wputs "You know, I can make your application look nice for you with Bootstrap 3. If you prefer, I can also reset every CSS settings and let you unleash your visual creativity (or have you call your favorite graphic designer).", :info
      end

      # select ui
      new_line
      wputs "- Which UI framework?"
      hputs "1. Reset CSS"
      hputs "2. Bootstrap 3 (default)"
      print "Your choice (1-2): "
      choice = STDIN.gets.chomp.strip
      options[:ui] = choice == "1" ? "reset" : "bootstrap3"


      # GIT
      new_line(2)
      wputs "10. Your Source Code Repository"
      wputs "*******************************"
      if @verbose
        wputs "I can create a local and a remote Git repository for you. If you choose to do so, I will also create a specific .gitignore files to make sure your secrets are not distributed with your code.", :info
      end

      # create git?
      new_line
      wputs "- Create a local Git repository?"
      print "Your choice (y/n): "
      choice = STDIN.gets.chomp.downcase.strip
      options[:git_local] = choice == "y"

      if options[:git_local]

        # remote git?
        new_line
        wputs "- Set up a remote repository?"
        print "Your choice (y/n): "
        choice = STDIN.gets.chomp.downcase.strip
        options[:git_remote] = choice == "y"

        if options[:git_remote]

          # git remote url
          new_line
          wputs "- What's your remote repository URL?"
          wputs "(example: https://github.com/yourname/yourapp.git)"
          print "Enter remote address: "
          options[:git_remote_url] = STDIN.gets.chomp.strip

        else
          options[:git_remote_url] = ""

        end

      else
        options[:git_remote] = false
        options[:git_remote_url] = ""

      end


      # SUMMARY
      new_line(2)
      wputs "11. SUMMARY"
      wputs "***********"
      if @verbose
        wputs "I now have all the information I need to start building your app. This will take a little while (between a few seconds and a few minutes, depending on the speed of your machine) so go have a coffee. When you are back, everything will be configured.", :info
      end

      # create app
      new_line
      wputs "- Create #{options[:app_name]} now?"
      wputs "(selecting anything other than 'y' will discard everything and exit the wizard)"
      new_line
      print "Your choice (y/n): "
      choice = STDIN.gets.chomp.downcase.strip
      options[:create] = choice == "y"

      options

    end

  end

  private


  def welcome
    new_line(2)
    wputs "***********************************"
    hputs " RailsBricks v#{Version.current}"
    new_line
    hputs " www.railsbricks.net"
    wputs "***********************************"
  end

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
