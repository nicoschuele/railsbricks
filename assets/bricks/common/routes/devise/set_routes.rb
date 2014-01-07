#!/usr/bin/env ruby
require ENV['HOME']+"/railsbricks/assets/common_scripts/app_name.rb"

template_path = ENV['HOME']+"/railsbricks/assets/bricks/common/routes/devise/routes.rb"
file_path = "config/routes.rb"
given_name = ARGV.shift

file_content = File.read(template_path)
file_content = replace_with_app_name(app_name(given_name), file_content)

File.open(file_path,"w") do |f|
  f.puts file_content
end