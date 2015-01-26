require "fileutils"
require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"
require_relative "file_helpers"
require_relative "config_values"

module GemfileBuilder
  BCRYPT = "3.1.9"
  BOOTSTRAP_SASS = "3.3.3"
  COFFEE_RAILS = "4.1.0"
  DEVISE = "3.4.1"
  FIGARO = "1.0.0"
  FONT_AWESOME_SASS = "4.2.2"
  FRIENDLY_ID = "5.1.0"
  JBUILDER = "2.2.6"
  JQUERY_RAILS = "4.0.3"
  KAMINARI = "0.16.2"
  REDCARPET = "3.2.2"
  SASS_RAILS = "5.0.1"
  SQLITE3 = "1.3.10"
  TURBOLINKS = "2.5.3"
  UGLIFIER = "2.6.0"
  BYEBUG = "3.5.1"
  WEB_CONSOLE = "2.0.0"
  SPRING = "1.2.0"

  def self.build_gemfile(app_dir, options)
    new_line(2)
    wputs "----> Generating Gemfile ...", :info

    rbricks_dir = File.dirname(__FILE__)
    add_gem = ""

    # Copy base Gemfile
    FileUtils.cp_r(rbricks_dir + "/assets/gemfile/Gemfile", app_dir)

    # Set Ruby version
    FileHelpers.replace_string(/BRICK_RUBY_VERSION/, options[:ruby_version], app_dir + "/Gemfile")

    # Database
    if options[:development_db] == "sqlite"
      add_gem = "# SQLite 3\ngroup :development, :test do\n  gem 'sqlite3', 'BRICK_SQLITE3_VERSION'\nend"
    else
      add_gem = "# PostgreSQL\ngem 'pg'"
    end
    FileHelpers.add_to_file(app_dir + "/Gemfile", add_gem)

    # Devise
    if options[:devise]
      add_gem = "# Devise: https://github.com/plataformatec/devise\ngem 'devise', 'BRICK_DEVISE_VERSION'"
      FileHelpers.add_to_file(app_dir + "/Gemfile", add_gem)
    end

    # Markdown (needed if Post resources)
    if options[:post_resources]
      add_gem = "# Redcarpet: https://github.com/vmg/redcarpet\ngem 'redcarpet', 'BRICK_REDCARPET_VERSION'"
      FileHelpers.add_to_file(app_dir + "/Gemfile", add_gem)
    end

    # Heroku
    if options[:production_settings][:target] == "heroku"
      add_gem = "# Rails 12factor for Heroku: https://github.com/heroku/rails_12factor\ngroup :production do\n  gem 'rails_12factor'\nend"
      FileHelpers.add_to_file(app_dir + "/Gemfile", add_gem)
      if options[:development_db] == "sqlite"
        add_gem = "# PostgreSQL gem for Heroku\ngroup :production do\n  gem 'pg'\nend"
        FileHelpers.add_to_file(app_dir + "/Gemfile", add_gem)
      end
    end

    # Unicorn
    if options[:production_settings][:unicorn]
      add_gem = "# Unicorn: http://unicorn.bogomips.org\ngroup :production do\n  gem 'unicorn'\nend"
      FileHelpers.add_to_file(app_dir + "/Gemfile", add_gem)
    end

    # Set gem versions
    FileHelpers.replace_string(/BRICK_BCRYPT_VERSION/, BCRYPT, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_BOOTSTRAP_SASS_VERSION/, BOOTSTRAP_SASS, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_COFFEE_RAILS_VERSION/, COFFEE_RAILS, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_DEVISE_VERSION/, DEVISE, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_FIGARO_VERSION/, FIGARO, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_FONT_AWESOME_SASS_VERSION/, FONT_AWESOME_SASS, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_FRIENDLY_ID_VERSION/, FRIENDLY_ID, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_JBUILDER_VERSION/, JBUILDER, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_JQUERY_RAILS_VERSION/, JQUERY_RAILS, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_KAMINARI_VERSION/, KAMINARI, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_RAILS_VERSION/, options[:rails_version], app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_REDCARPET_VERSION/, REDCARPET, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_SASS_RAILS_VERSION/, SASS_RAILS, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_SQLITE3_VERSION/, SQLITE3, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_TURBOLINKS_VERSION/, TURBOLINKS, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_UGLIFIER_VERSION/, UGLIFIER, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_BYEBUG_VERSION/, BYEBUG, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_WEB_CONSOLE_VERSION/, WEB_CONSOLE, app_dir + "/Gemfile")
    FileHelpers.replace_string(/BRICK_SPRING_VERSION/, SPRING, app_dir + "/Gemfile")

    new_line
    wputs "----> Gemfile generated.", :info

  rescue
    Errors.display_error("Something went wrong and the Gemfile couldn't be generated. Stopping app creation.", true)
    abort

  end

  def self.wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

  def self.new_line(lines=1)
    StringHelpers.new_line(lines)
  end

end
