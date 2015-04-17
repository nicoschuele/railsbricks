require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"
require_relative "config_values"
require "etc"

class Menu

  attr_accessor :options

  def initialize
    @options = {railsbricks_version: Version.to_s}
  end

  def new_app_menu
    # WELCOME
    @options[:rails_version] = ConfigValues.rails_version
    new_line
    wputs '*****************************'
    wputs "*                           *"
    wputs "*     RailsBricks #{Version.to_s}     *"
    wputs '*    www.railsbricks.net    *'
    wputs "*                           *"
    wputs "*     using Rails #{@options[:rails_version]}     *"
    wputs "*                           *"
    wputs '*****************************'
    new_line(2)

    # WIZARD CONFIG
    wputs "- Do you want me to help you along the way by giving you tips?"
    wputs "1. Sure, help me make the right choices (default)", :info
    wputs "2. Nope, I already know how to use RailsBricks", :info
    hints = answer() == "2" ? false : true
    new_line(2)

    # APP NAME
    wputs "1. Your Rails App Name"
    wputs "----------------------"
    if hints
      wputs "First of all, you need to give a name to your new app. I'll create it in #{Dir.pwd}/. Of course, only use a valid Rails app name.", :help
    end
    new_line
    wputs "- What do you want to name your app?"
    default_name = "railsbricks_#{4.times.map{ 0 + Random.rand(9)}.join}"
    wputs "(default: #{default_name})"
    @options[:app_name] = StringHelpers.sanitize(answer("App name:"))
    @options[:app_name] = default_name if @options[:app_name].length < 1
    @options[:rails_app_name] = StringHelpers.convert_to_app_name(@options[:app_name])
    new_line(2)

    # DEVELOPMENT ENVIRONMENT
    wputs "2. Your Development Environment"
    wputs "-------------------------------"

    # ruby version
    if hints
      wputs "Before I can create your app, I need more information about your current development environment. Note that I don't support versions of Ruby older than 2.0.0.", :help
    end
    new_line
    wputs "- Which version of Ruby do you want to use?"
    wputs "1. 2.0.0", :info
    wputs "2. 2.2.1", :info
    wputs "3. 2.2.2 (default)", :info
    choice = answer("Your choice (1-3):")
    case choice
    when "1"
      @options[:ruby_version] = "2.0.0"
    when "2"
      @options[:ruby_version] = "2.2.1"
    else
      @options[:ruby_version] = "2.2.2"
    end
    new_line(2)

    # gem command
    if hints
      wputs "On some systems, you can't install gems by issuing a simple 'gem install name_of_gem' command but need to prefix it with 'sudo' and issue 'sudo gem install name_of_gem'. If this is the case, you most likely will need to input your password at some point.", :help
    end
    new_line
    wputs "- How do you usually install new gems?"
    wputs "1. gem install name_of_gem (default)", :info
    wputs "2. sudo gem install name_of_gem", :info
    @options[:gem_command] = answer() == "2" ? "sudo gem" : "gem"
    new_line(2)

    # rake command
    if hints
      wputs "Do you usually run rake tasks by prefixing them with 'bundle exec'? I also need to know that.", :help
    end
    new_line
    wputs "- How do you usually run rake tasks?"
    wputs "1. rake some_task (default)", :info
    wputs "2. bundle exec rake some_task", :info
    @options[:rake_command] = answer() == "2" ? "bundle exec rake" : "rake"
    new_line(2)

    # development database
    if hints
      wputs "By default, Rails uses SQLite 3 to store the development database. I can change that to PostgreSQL but you have to make sure that a PostgreSQL server is installed and currently running. If it doesn't, the app creation will fail as I won't be able to create the development database.", :help
    end
    new_line
    wputs "If you are on OS X, I struggle with the Postgres.app as the location of pg_config keeps changing between versions. If you want to use PostgreSQL, you'll have to use a full install which you can get through Homebrew by running 'brew install postgresql'.", :error
    new_line
    wputs "- Which database engine do you want to use for development?"
    wputs "1. SQLite 3 (default)", :info
    wputs "2. PostgreSQL", :info
    @options[:development_db] = answer() == "2" ? "postgresql" : "sqlite"
    @options[:db_config] = {}
    new_line(2)

    # postgresql config
    if @options[:development_db] == "postgresql"
      if hints
        wputs "Right, you decided to go with PostgreSQL. Note that I will only create a development config. You'll have to manually edit #{@options[:app_name]}/config/database.yml for test and production. I will create the database so make sure it doesn't exist yet.", :help
        new_line
      end

      # hostname
      wputs "- Your database server hostname?"
      wputs "example: 192.168.1.1, localhost, ...", :help
      wputs "(default: localhost)"
      choice = answer("Hostname:")
      @options[:db_config][:server] = choice == "" ?  "localhost" : choice
      new_line(2)

      # port
      wputs "- What is the database port number?"
      wputs "(default: 5432)"
      choice = answer("Port:")
      @options[:db_config][:port] = choice == "" ? 5432 : choice.to_i
      new_line(2)

      # name
      wputs "- What is the development database name?"
      wputs "(default #{@options[:app_name].downcase}_development)"
      choice = StringHelpers.sanitize(answer("Database name:"))
      @options[:db_config][:name] = choice == "" ?  "#{@options[:app_name].downcase}_development" : choice
      new_line(2)

      # username
      wputs "- What is your database username?"
      wputs "(default: #{Etc.getlogin})"
      choice = answer("Database username:")
      @options[:db_config][:username] = choice == "" ? "#{Etc.getlogin}" : choice
      new_line(2)

      # password
      wputs "- What is your database user password?"
      wputs "tip: leave blank for none", :help
      wputs "(default: none)"
      @options[:db_config][:password] = answer("Database user password:")
      new_line(2)

    else
      @options[:db_config][:server] = nil
      @options[:db_config][:port] = nil
      @options[:db_config][:name] = nil
      @options[:db_config][:username] = nil
      @options[:db_config][:password] = nil
    end

    # git local
    if hints
      wputs "I can create a local and a remote Git repository for you. If you choose to do so, I will also create a specific .gitignore file to make sure your secrets are not distributed with your code.", :help
    end
    new_line
    wputs "- Create a local Git repository?"
    wputs "1. Yes (default)", :info
    wputs "2. No", :info
    answer() == "2" ? @options[:local_git] = false : @options[:local_git] = true
    new_line(2)

    # git remote
    if @options[:local_git]
      wputs "- Add a remote Git repository?"
      wputs "1. Yes", :info
      wputs "2. No (default)", :info
      answer() == "1" ? @options[:remote_git] = true : @options[:remote_git] = false
      new_line(2)
    else
      @options[:remote_git] = false
    end

    # git remote url
    if @options[:remote_git]
      wputs "- What is the URL of your remote Git repository?"
      wputs "example: https://github.com/yourname/your_app.git", :help
      @options[:git_url] = answer("Remote URL:")
      new_line(2)
    else
      @options[:git_url] = ""
    end


    # APP INFO
    wputs "3. About Your App"
    wputs "-----------------"

    # devise
    if hints
      wputs "If your app will have users, I can create an authentication scheme using Devise. If you want me to create resources accessible from an admin zone (blog posts, for example), you will need to have an authentication scheme.", :help
    end
    new_line
    wputs "- Create an authentication scheme?"
    wputs "1. Yes (default)", :info
    wputs "2. No", :info
    @options[:devise] = answer() == "2" ? false : true
    @options[:devise_config] = {}
    new_line(2)

    if @options[:devise]
      # sign in
      if hints
        wputs "You can choose what credentials users will need to provide to sign in. Whether with a username and a password or with an email address and a password.", :help
        new_line
      end
      wputs "- How will users sign in?"
      wputs "1. With a username (default)", :info
      wputs "2. With an email address", :info
      @options[:devise_config][:scheme] = answer() == "2" ? "email" : "username"
      new_line(2)

      # allow sign up
      if hints
        wputs "If you don't want to allow new users to register, I can disable the sign up feature.", :help
        new_line
      end
      wputs "- Allow new users to sign up?"
      wputs "1. Yes, they can click on a 'sign up' button (default)", :info
      wputs "2. No, I don't want to allow new users to sign up", :info
      @options[:devise_config][:allow_signup] = answer() == "2" ? false : true
      new_line(2)

      # test users
      if hints
        wputs "I can also create 50 test users for you if you need.", :help
        new_line
      end
      wputs "- Create test users?"
      wputs "1. No, only create my Admin account (default)", :info
      wputs "2. Yes, create 50", :info
      @options[:devise_config][:test_users] = answer() == "2" ? true : false
      new_line(2)

      # post model
      if hints
        wputs "I can create a Post model which is useful if you intend to have a blog, news, articles, etc, in your app. The appropriate model, routes, controllers and views will be created and useable in the admin zone. You will be able to add new posts using the Markdown syntax. To change settings such as how many posts are displayed on a page, refer to the RailsBricks documentation.", :help
        new_line
      end
      wputs "- Create Post resources?"
      wputs "1. Yes", :info
      wputs "2. No (default)", :info
      @options[:post_resources] = answer() == "1" ? true : false
      new_line(2)
    else
      @options[:devise_config][:scheme] = nil
      @options[:devise_config][:allow_signup] = nil
      @options[:devise_config][:test_users] = nil
      @options[:post_resources] = false
    end

    # contact form
    if hints
      wputs "I can create a Contact form for you. Your visitors will be able to fill in their name, email address and their message to you. Note that I won't allow visitors to send you links in order to cut down on spam! To change the contact form settings, refer to the RailsBricks documentation.", :help
      new_line
    end
    wputs "- Create a Contact form?"
    wputs "1. Yes", :info
    wputs "2. No (default)", :info
    @options[:contact_form] = answer() == "1" ? true : false
    new_line(2)

    # google analytics
    if hints
      wputs "I can already generate the necessary bits of code for using Google Analytics. It will work with Turbolinks, don't worry. You will need to provide me with your Google Analytics Tracking ID. It's a string like UA-000000-01. If you don't have one yet, I will use UA-XXXXXX-XX and you can set it later within #{@options[:app_name]}/app/views/layouts/_footer.html.erb.", :help
      new_line
    end
    wputs "- Use Google Analytics?"
    wputs "1. Yes (default)", :info
    wputs "2. No", :info
    @options[:google_analytics] = answer() == "2" ? false : true
    new_line(2)

    if @options[:google_analytics]
      wputs "- What is your Google Analytics tracking ID?"
      wputs "(default: UA-XXXXXX-XX)"
      choice = answer("Tracking ID:", false)
      @options[:google_tracking_id] = choice == "" ? "UA-XXXXXX-XX" : choice
      new_line(2)
    else
      @options[:google_tracking_id] = nil
    end

    # email settings
    if hints
      wputs "Your app can send emails. It is even required if you chose to add a contact form or let new users sign up. Let's go through the basic settings I need to know. If you choose not to configure your email settings now, you can do it at a later stage by editing the relevant section within #{@options[:app_name]}/config/application.yml.", :help
      new_line
    end
    wputs "- Configure email settings?"
    wputs "1. Yes (default)", :info
    wputs "2. No", :info
    @options[:email_settings] = answer() == "2" ? false : true
    @options[:email_config] = {}
    new_line(2)

    if @options[:email_settings]
      #sender
      wputs "- What is the email address you will send emails from?"
      wputs "example: someone@example.com", :help
      @options[:email_config][:sender] = answer("Email address:")
      new_line(2)

      # smtp server
      wputs "- What is your SMTP server address?"
      wputs "example: smtp.example.com", :help
      @options[:email_config][:smtp] = answer("SMTP server:")
      new_line(2)

      # domain
      wputs "- What is the domain name of your SMTP server?"
      wputs "example: 192.168.1.1, example.com, ...", :help
      @options[:email_config][:domain] = answer("Domain name:")
      new_line(2)

      # port
      wputs "- What is the SMTP server port number?"
      wputs "(default: 587)"
      choice = answer("SMTP port:")
      @options[:email_config][:port] = choice == "" ? "587" : choice
      new_line(2)

      # username
      wputs "- What is your SMTP username?"
      @options[:email_config][:username] = answer("SMTP username:")
      new_line(2)

      # password
      wputs "- What is your SMTP password?"
      wputs "tip: it will be stored in #{@options[:app_name]}/config/application.yml but won't be tracked by Git", :help
      @options[:email_config][:password] = answer("SMTP password:", false)
      new_line(2)

    else
      @options[:email_config][:sender] = nil
      @options[:email_config][:smtp] = nil
      @options[:email_config][:domain] = nil
      @options[:email_config][:port] = nil
      @options[:email_config][:username] = nil
      @options[:email_config][:password] = nil
    end

    # UI
    wputs "4. Your App UI"
    wputs "--------------"
    @options[:ui] = {}

    # body theme
    if hints
      wputs "I will use Bootstrap 3 to build the UI of your app. You can change Boostrap default values by editing #{@options[:app_name]}/app/assets/railsbricks_custom.scss.", :help
    end
    new_line
    wputs "- Which UI scheme do you want to use for the content area?"
    wputs "1. Light (default)", :info
    wputs "2. Dark", :info
    @options[:ui][:theme_background] = answer() == "2" ? "dark" : "light"
    new_line(2)

    # navbar theme
    new_line
    wputs "- Which UI scheme do you want to use for the navbar?"
    wputs "1. Light", :info
    wputs "2. Dark (default)", :info
    @options[:ui][:theme_navbar] = answer() == "1" ? "light" : "dark"
    new_line(2)

    # footer theme
    new_line
    wputs "- Which UI scheme do you want to use for the footer?"
    wputs "1. Light", :info
    wputs "2. Dark (default)", :info
    @options[:ui][:theme_footer] = answer() == "1" ? "light" : "dark"
    new_line(2)


    # primary color
    if hints
      wputs "The primary color is expressed as a hexadecimal value such as #663399 (purple). In #{@options[:app_name]}/app/assets/railsbricks_custom.scss, the primary color is assigned to a variable named '$brand-primary'. It is used as the base color for links, default buttons, etc... .", :help
      new_line
    end
    wputs "- What primary color do you want to use?"
    wputs "tip: expressed as hexadecimal such as #663399", :help
    wputs "(default: #428BCA)"
    choice = answer("Primary color:")
    @options[:ui][:color] = choice == "" ? "#428bca" : choice.downcase
    new_line(2)

    # font
    if hints
      wputs "Fonts are an important part of you app. You can see what each proposed font looks like by searching for their names on Google Fonts.", :help
      new_line
    end
    wputs "- Which font family and fallback options do you want to use as the main one for the UI?"
    wputs "1. Open Sans, Helvetica, Arial, sans-serif (default)", :info
    wputs "2. Arial, Helvetica, sans-serif", :info
    wputs "3. Gentium Basic, Times New Roman, serif", :info
    wputs "4. Anonymous Pro, Courier New, monospace", :info
    choice = answer("Your choice (1-4):")
    case choice
    when "2"
      @options[:ui][:font] = "arial"
    when "3"
      @options[:ui][:font] = "gentium"
    when "4"
      @options[:ui][:font] = "anonymous"
    else
      @options[:ui][:font] = "open"
    end
    new_line(2)

    # PRODUCTION
    wputs "5. Your Production Settings"
    wputs "---------------------------"

    # production
    if hints
      wputs "At some point, you will deploy your app to a production environment. I can already set up some settings for you.", :help
    end
    new_line
    wputs "- Do you want to set up some production settings already?"
    wputs "1. Yes (default)", :info
    wputs "2. No", :info
    @options[:production] = answer() == "2" ? false : true
    @options[:production_settings] = {}
    new_line(2)

    if @options[:production]
      # heroku
      if hints
        wputs "If you opt to host your app with Heroku, I can already add the necessary 12 Factor gem to a production group within your Gemfile.", :help
        new_line
      end
      wputs "- Where will you host your app?"
      wputs "1. Heroku (default)", :info
      wputs "2. Somewhere else", :info
      @options[:production_settings][:target] = answer() == "2" ? "else" : "heroku"
      new_line(2)

      # url
      wputs "- What will be the URL of your app?"
      wputs "example: www.my-app.com, blog.my-app.com, ...", :help if hints
      wputs "tip: don't prefix the URL with http://", :help
      @options[:production_settings][:url] = answer("URL:")
      new_line(2)

      # unicorn
      if hints
        wputs "By default, Rails apps use WEBrick as a simple HTTP web server. Although it is a good web server for development purpose, it is not really advised to use it in a production environment. I can configure your app to use Unicorn in production. If you choose so, I will add the Unicorn gem to your Gemfile within the :production group, create a unicorn.rb file within #{@options[:app_name]}/config and add a Procfile to your app root. You can edit Unicorn settings in #{@options[:app_name]}/config/unicorn.rb if you need to.", :help
        new_line
      end
      wputs "- Do you want to use Unicorn in production?"
      wputs "1. Yes (default)", :info
      wputs "2. No", :info
      @options[:production_settings][:unicorn] = answer() == "2" ? false : true
      new_line(2)
    else
      @options[:production_settings][:target] = nil
      @options[:production_settings][:url] = nil
      @options[:production_settings][:unicorn] = nil
    end

    # SUMMARY
    wputs "6. Summary"
    wputs "----------"
    # TODO: Offer to save template and/or whole script

    # if hints
    #   wputs "I now have all the details needed to create #{@options[:app_name]}. I can save your settings if you want to generate your application at a later time (for example, if you forgot to start your PostgreSQL server). This will generate a file named #{@options[:app_name]}.rbs in the current directory. You can execute it later by running: rbricks --script #{@options[:app_name]}.rbs", :help

    #   new_line

    #   wputs "I can also save your chosen settings in a template file if you plan to create similar apps at a later stage. You will only need to fill in unique settings such as the app name. The template will be saved in the current directory as template_#{@options[:app_name]}.rbt. You can execute it later by running: rbricks --template template_#{@options[:app_name]}.rbt", :help
    # end
    new_line

    # # save settings
    # wputs "- Do you want to save the app settings in order to execute them later?"
    # wputs "tip: rbricks --script #{@options[:app_name]}.rbs", :help
    # wputs "1. Yes", :info
    # wputs "2. No (default)", :info
    # @options[:save_settings] = answer() == "1" ? true : false
    # new_line(2)

    # # save template
    # wputs "- Do you want to save common settings as a template?"
    # wputs "tip: rbricks --template template_#{@options[:app_name]}.rbt", :help
    # wputs "1. Yes", :info
    # wputs "2. No (default)", :info
    # @options[:save_template] = answer() == "1" ? true : false
    # new_line(2)

    # generate now
    wputs "- I am ready! Generate #{@options[:app_name]} now?"
    wputs "1. Do it! (default)", :info
    wputs "2. No, not now", :info
    @options[:generate] = answer() == "2" ? false : true
    new_line

    @options

  end

  # Shortcut/alias methods

  private

  def wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

  def new_line(lines=1)
    StringHelpers.new_line(lines)
  end

  def answer(choices="Your choice (1-2):", is_downcase = true)
    print "#{choices} "
    if is_downcase
      STDIN.gets.chomp.downcase.strip
    else
      STDIN.gets.chomp.strip
    end
  end

end
