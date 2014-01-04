#!/usr/bin/env ruby
require ENV['HOME']+"/railsbricks/assets/common_scripts/app_name.rb"

template_path = ENV['HOME']+"/railsbricks/assets/secret_token/secret_token.rb"
token_path = "config/initializers/secret_token.rb"
given_name = ARGV.shift

token_content = File.read(template_path)
token_content = replace_with_app_name(app_name(given_name), token_content)

File.open(token_path,"w") do |f|
  f.puts token_content
end