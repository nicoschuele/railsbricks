require_relative "string_helpers"

module Errors

  def self.display_error(msg, show_issues_url = false)
    puts
    StringHelpers.wputs msg, :error
    puts

    if show_issues_url
      StringHelpers.wputs "If you can't fix this error, please file an issue report at https://github.com/nicoschuele/railsbricks/issues"
      puts
    end

  end

end