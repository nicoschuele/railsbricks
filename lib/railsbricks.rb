require_relative "railsbricks/version"
require_relative "railsbricks/string_helpers"
require_relative "railsbricks/errors"
require_relative "railsbricks/menu"
require_relative "railsbricks/app_generator"
require_relative "railsbricks/config_helpers"

class Railsbricks

  def self.main(args)
    # new app
    if args[0] == '-n' || args[0] == '--new'
      new_app
    elsif args[0] == '-r' || args[0] == '--recreate-db'
      recreate_db
    elsif args[0] == '-a' || args[0] == '--annotate'
      annotate
    elsif args[0] == '--robocop'
      prime_directives
    elsif args[0] == '-v' || args[0] == '--version'
      display_version
    elsif args[0] == '--config'
      display_config
    else
      display_help
    end
  end

  def self.new_app
    menu = Menu.new
    @options = menu.new_app_menu
    generator = AppGenerator.new(@options)
    generator.generate_app
  end

  def self.recreate_db
    options = ConfigHelpers.load_config
    puts
    StringHelpers.wputs "----> Recreating the database ...", :info
    system "#{options["rake_command"]} db:drop"
    system "#{options["rake_command"]} db:create:all"
    system "#{options["rake_command"]} db:migrate"
    system "#{options["rake_command"]} db:seed"
    puts
    StringHelpers.wputs "----> Database recreated.", :info
    puts
  end

  def self.annotate
    puts
    StringHelpers.wputs "----> Annotating models and routes ...", :info
    puts
    system "bundle exec annotate"
    system "bundle exec annotate --routes"
    puts
    StringHelpers.wputs "----> Models and routes annotated.", :info
    puts
  end

  def self.prime_directives
    Errors.display_error "1. Serve the public trust"
    Errors.display_error "2. Protect the innocent"
    Errors.display_error "3. Uphold the law"
    Errors.display_error "4. Classified"
  end

  def self.display_version
    puts
    StringHelpers.wputs "RailsBricks #{Version.current} (#{Version.current_date})", :info
    StringHelpers.wputs "www.railsbricks.net", :info
    StringHelpers.wputs "source: https://github.com/nicoschuele/railsbricks", :help
    StringHelpers.wputs "by Nico Schuele (www.nicoschuele.com)", :help
    puts
  end

  def self.display_config
    puts
    StringHelpers.wputs "----> Retrieving your app's RailsBricks config values ...", :info
    options = ConfigHelpers.load_config
    puts
    if options.count > 1
      options.each do |k,v|
        StringHelpers.wputs "#{k}: #{v}"
      end
    else
      Errors.display_error "Config values couldn't be found. In most cases, this is because '#{ConfigHelpers::CONFIG_PATH}/config' is not within your app.", true
    end
    puts
    StringHelpers.wputs "----> App config values retrieved.", :info
  rescue
    Errors.display_error "Config values couldn't be found. In most cases, this is because '#{ConfigHelpers::CONFIG_PATH}/config' is not within your app.", true
  end

  def self.display_help
    puts
    StringHelpers.wputs "RailsBricks usage:", :info
    StringHelpers.wputs "------------------", :info
    puts
    puts "rbricks --new (or -n) :"
    puts "  --> create a new RailsBricks app."
    puts
    puts "rbricks --recreate-db (or -r) :"
    puts "  --> drop, create, migrate & seed the DB"
    puts
    puts "rbricks --config"
    puts "  --> display your app config"
    puts
    puts "rbricks --version (or -v) :"
    puts "  --> display the RailsBricks version"
    puts
    StringHelpers.wputs "More help, tutorials and documentation at http://www.railsbricks.net/get-started", :info
    puts
  end

end
