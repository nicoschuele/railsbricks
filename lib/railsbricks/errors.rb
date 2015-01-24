require_relative "string_helpers"
require_relative "config_values"

module Errors

  def self.display_error(msg, show_issues_url = false)
    puts
    StringHelpers.wputs msg, :error
    puts

    if show_issues_url
      StringHelpers.wputs "If you can't fix this error, please file an issue report at #{ConfigValues.issue_path}"
      puts
    end

  end

end
