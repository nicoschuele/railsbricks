# TODO: finish the Validator class and use it!
require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"


class Validator
  
  attr_accessor :log
  
  def initialize(options = {})
    @log = []
    @options = options
  end
  
  
  def validate(validate = :script, abort_on_error = true)
    add_error("RailsBricks version not set") if @options[:railsbricks_version].to_s == ''
    add_error("Rails version not set") if @options[:rails_version].to_s == ''
    add_error("App name not set") if @options[:app_name].to_s == ''
    add_error("Rails app name not set") if @options[:rails_app_name].to_s == ''
    add_error("Ruby version not set") if @options[:ruby_version].to_s == ''
    add_error("Gem command not set") if @options[:gem_command].to_s == ''
    add_error("Rake command not set") if @options[:rake_command].to_s == ''
    add_error("Database engine not set") if @options[:development_db].to_s == ''
    
    if @options[:development_db].to_s == "postgresql"
      add_error("PostgreSQL server not set") if @options[:db_config][:server].to_s == ''
      add_error("PostgreSQL port not set") if @options[:db_config][:port].to_s == ''
      add_error("PostgreSQL database name not set") if @options[:db_config][:name].to_s == ''
      add_error("PostgreSQL username not set") if @options[:db_config][:username].to_s == ''
    end
    
    add_error("Local Git option not set") if @options[:local_git].nil?
    add_error("Remote Git option not set") if @options[:remote_git].nil?
    
    if @options[:remote_git]
      add_error("Remote Git URL not set") if @options[:git_url].to_s == ''
    end
    
    add_error("Devise option not set") if @options[:devise].nil?
    
    if @options[:devise]
      
    end
    
  end
  
  
  
  # Shortcut/alias methods
  
  private
  
  def add_error(msg = "")
    if msg.to_s == ''
      @log << "Unspecified error found"
    else
      @log << "Error: #{msg}"
    end
  end
  
  def wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end  
  
  def new_line(lines=1)
    StringHelpers.new_line(lines)
  end
  
end