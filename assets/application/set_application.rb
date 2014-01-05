#!/usr/bin/env ruby
require ENV['HOME']+"/railsbricks/assets/common_scripts/app_name.rb"

template_path = ENV['HOME']+"/railsbricks/assets/application/application.rb"
application_path = "config/application.rb"
given_name = ARGV.shift

application_content = File.read(template_path)
application_content = replace_with_app_name(app_name(given_name), application_content)

File.open(application_path,"w") do |f|
  f.puts application_content
end