require_relative "ui_helpers"

module StringHelpers

  # replaces special characters with '_'
  def self.sanitize(value)
    value.tr('^A-Za-z0-9', '_')
  end
 
  # simply displays empty lines
  def self.new_line(lines=1)
    lines.times { puts }
  end
  
  # convert a string to a valid Rails app name
  def self.convert_to_app_name(value)
    if value.scan(/\_|\-/).size > 0
      value.split(/\_|\-/).map(&:capitalize).join
    else
      value.slice(0,1).capitalize + value.slice(1..-1)
    end
  end
  
  # Wraps output text at 79 columns. 
  # Outputs in green if highlight = :info / red if :error / blue if :help
  def self.wputs(text, highlight = :none)
    text = text.gsub(/\n/, ' ').gsub(/(.{1,#{79}})(\s+|$)/, "\\1\n").strip
    if highlight == :info
      puts UiHelpers.colorize(text, UiHelpers::GREEN)
    elsif highlight == :error
      puts UiHelpers.colorize(text, UiHelpers::RED)
    elsif highlight == :help
      puts UiHelpers.colorize(text, UiHelpers::BLUE)
    else
      puts text
    end
  
  end
  
end