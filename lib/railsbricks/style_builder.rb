require "fileutils"
require_relative "ui_helpers"
require_relative "version"
require_relative "string_helpers"
require_relative "file_helpers"
require_relative "config_values"

module StyleBuilder

  def self.build_style(app_dir, options)
    new_line(2)
    wputs "----> Generating stylesheets ...", :info

    rbricks_dir = File.dirname(__FILE__)
    add_style = ""

    # Copy base stylesheets
    FileUtils.cp_r(rbricks_dir + "/assets/stylesheets/.", app_dir + "/app/assets/stylesheets")

    # Theme background
    if options[:ui][:theme_background] == "light"
      FileHelpers.replace_string(/BRICK_BODY_COLOR/, "#ffffff", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_TEXT_COLOR/, "#373737", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_HEADINGS_SMALL_COLOR/, "#bbbbbb", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
    else
      FileHelpers.replace_string(/BRICK_BODY_COLOR/, "#2b2b2b", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_TEXT_COLOR/, "#eeeeee", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_HEADINGS_SMALL_COLOR/, "#cccccc", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
    end

    # Theme navbar
    if options[:ui][:theme_navbar] == "dark"
      FileHelpers.replace_string(/BRICK_NAVBAR_COLOR/, "navbar-inverse", app_dir + "/app/views/layouts/_navigation.html.erb")
    else
      FileHelpers.replace_string(/BRICK_NAVBAR_COLOR/, "navbar-default", app_dir + "/app/views/layouts/_navigation.html.erb")
    end

    # Theme footer
    if options[:ui][:theme_footer] == "dark"
      FileHelpers.replace_string(/BRICK_FOOTER_BACKGROUND_COLOR/, "#222222", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FOOTER_COLOR/, "#eeeeee", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
    else
      FileHelpers.replace_string(/BRICK_FOOTER_BACKGROUND_COLOR/, "#ffffff", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FOOTER_COLOR/, "#373737", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
    end

    # Brand color
    FileHelpers.replace_string(/BRICK_BRAND_COLOR/, "#{options[:ui][:color]}", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")

    # Font
    if options[:ui][:font] == "arial"
      FileHelpers.replace_string(/BRICK_FONT_IMPORT/, "// Import fonts with: @import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SANS_SERIF/, "Arial, Helvetica, sans-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SERIF/, "Georgia, 'Times New Roman', Times, serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_MONOSPACE/, "'Menlo','Monaco','Consolas','Courier New', monospace", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_BASE/, "$font-family-sans-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")

    elsif options[:ui][:font] == "gentium"
      FileHelpers.replace_string(/BRICK_FONT_IMPORT/, "@import url(http://fonts.googleapis.com/css?family=Gentium+Basic:400,700,400italic,700italic);", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SANS_SERIF/, "Arial, Helvetica, sans-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SERIF/, "'Gentium Basic', Times New Roman, serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_MONOSPACE/, "'Menlo','Monaco','Consolas','Courier New', monospace", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_BASE/, "$font-family-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")

    elsif options[:ui][:font] == "anonymous"
      FileHelpers.replace_string(/BRICK_FONT_IMPORT/, "@import url(http://fonts.googleapis.com/css?family=Anonymous+Pro:400,400italic,700,700italic);", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SANS_SERIF/, "Arial, Helvetica, sans-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SERIF/, "Georgia, 'Times New Roman', Times, serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_MONOSPACE/, "'Anonymous Pro', Courier New, monospace", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_BASE/, "$font-family-monospace", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")

    else
      FileHelpers.replace_string(/BRICK_FONT_IMPORT/, "@import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,700italic,400,700);", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SANS_SERIF/, "'Open Sans', Helvetica, Arial, sans-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_SERIF/, "Georgia, 'Times New Roman', Times, serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_MONOSPACE/, "'Menlo','Monaco','Consolas','Courier New', monospace", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
      FileHelpers.replace_string(/BRICK_FONT_BASE/, "$font-family-sans-serif", app_dir + "/app/assets/stylesheets/railsbricks_custom.scss")
    end

    new_line
    wputs "----> Stylesheets generated.", :info

  rescue
    Errors.display_error("Something went wrong and the stylesheets couldn't be generated. Stopping app creation.", true)
    abort

  end

  def self.wputs(text, highlight = :none)
    StringHelpers.wputs(text, highlight)
  end

  def self.new_line(lines=1)
    StringHelpers.new_line(lines)
  end

end
