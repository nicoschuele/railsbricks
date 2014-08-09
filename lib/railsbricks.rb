require_relative "railsbricks/version"
require_relative "railsbricks/menu"
require_relative "railsbricks/string_helpers"
require_relative "railsbricks/errors"
require_relative "railsbricks/app_creator"

class Railsbricks

  def self.select(args)

    # new app
    if args[0] == "-n" || args[0] == "--new"
      args[1] == "--shut-up" ? new_app(false) : new_app

    # recreate DB
    elsif args[0] == "-r" || args[0] == "--recreate"
      db_recreate

    # install gems in vendor path
    elsif args[0] == "-b" || args[0] == "--bundle"
      bundle_install

    # update RailsBricks
    elsif args[0] == "--update"
      rbricks_update

    # version
    elsif args[0] == "-v" || args[0] == "--version"
      version

    # check latest version number
    elsif args[0] == "-l" || args[0] == "--latest"
      latest_version

    # prime directives
    elsif args[0] == "--robocop"
      robocop

    # display config values
    elsif args[0] == "--config"
      display_config

    # adds a brick
    elsif args[0] == "-a" || args[0] == "--add"
      # TODO implement bricks add-on system
      puts "Not implemented yet!"

    # error: for future debug info. Implement a log file?
    elsif args[0] == "--error"
      Errors.display_error("Something awful just happened")

    else
      display_help

    end

  end

  def self.new_app(verbose = true)
    menu = Menu::WizardMenu.new(verbose)
    options = menu.display_menu

    if options && options[:create] == true
      app = AppCreator::new(options)
    end

  end

  def self.version
    puts
    StringHelpers.wputs "RailsBricks #{Version.current} by Nico Schuele (www.nicoschuele.com) <nico@railsbricks.net> - http://www.railsbricks.net - source: https://github.com/nicoschuele/railsbricks", :info
    puts
  end

  def self.bundle_install
    puts
    StringHelpers.wputs "----> Installing required gems in 'vendor/bundle' without production ...  ", :info
    StringHelpers.wputs "(...please wait...)", :error
    puts `bundle install --without production --path vendor/bundle`
    puts
    StringHelpers.wputs "----> Gems installed in 'vendor/bundle'.", :info
    puts
  end

  def self.display_config
    puts
    StringHelpers.wputs "----> Retrieving your app's RailsBricks config values ...", :info
    options = ConfigHelpers.load_config
    puts
    options.each do |k,v|
      StringHelpers.wputs "#{k}: #{v}"
    end
    puts
    StringHelpers.wputs "----> App config values retrieved.", :info

  rescue
    Errors.display_error "Config values couldn't be found. In most cases, this is because '#{ConfigHelpers::CONFIG_PATH}/config' is not within your app.", true

  end

  def self.robocop
    Errors.display_error "1. Serve the public trust"
    Errors.display_error "2. Protect the innocent"
    Errors.display_error "3. Uphold the law"
    Errors.display_error "4. Classified"
  end

  def self.display_help
    puts
    StringHelpers.wputs "RailsBricks usage:", :info
    StringHelpers.wputs "------------------", :info
    puts
    puts "rbricks --new (or -n) [--shut-up] :"
    puts "  --> create a new RailsBricks app."
    puts "      use the --shut-up switch to turn off verbose mode"
    puts
    puts "rbricks --recreate (or -r) :"
    puts "  --> drop, create, migrate & seed the DB"
    puts
    puts "rbricks --update"
    puts "  --> update RailsBricks to the latest version"
    puts
    puts "rbricks --add (or -a)"
    puts "  --> adds a plug-in to your app (not implemented yet)"
    puts
    puts "rbricks --config"
    puts "  --> display your app config"
    puts
    puts "rbricks --version (or -v) :"
    puts "  --> display RailsBricks version"
    puts
    StringHelpers.wputs "More help, tutorials and documentation at http://www.railsbricks.net/get-started", :info
    puts

  end

  def self.db_recreate
    # get config
    options = ConfigHelpers.load_config
    puts
    StringHelpers.wputs "----> Recreating the database ...", :info
    puts `#{options["rake_command"]} db:drop`
    puts `#{options["rake_command"]} db:create:all`
    puts `#{options["rake_command"]} db:migrate`
    puts `#{options["rake_command"]} db:seed`


    puts
    StringHelpers.wputs "----> Database recreated.", :info
    puts

  rescue
    Errors.display_error "RailsBricks couldn't recreate your database.", true

  end

  def self.rbricks_update
    puts
    StringHelpers.wputs "----> Getting RailsBricks latest version ...", :info
    puts
    puts `gem update railsbricks`
    puts
    StringHelpers.wputs "----> Latest version of RailsBricks installed.", :info

  rescue
    Errors.display_error "Couldn't update RailsBricks. This is most likely due to your network settings.", true

  end

end