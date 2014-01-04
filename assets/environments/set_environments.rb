#!/usr/bin/env ruby
require ENV['HOME']+"/railsbricks/assets/common_scripts/app_name.rb"

dev_template_path = ENV['HOME']+"/railsbricks/assets/environments/development.rb"
prod_template_path = ENV['HOME']+"/railsbricks/assets/environments/production.rb"
dev_path = "config/environments/development.rb"
prod_path = "config/environments/production.rb"
given_name = ARGV.shift

dev_content = File.read(dev_template_path)
dev_content = replace_with_app_name(app_name(given_name), dev_content)

prod_content = File.read(prod_template_path)
prod_content = replace_with_app_name(app_name(given_name), prod_content)


File.open(dev_path,"w") do |f|
  f.puts dev_content
end

File.open(prod_path,"w") do |f|
  f.puts prod_content
end