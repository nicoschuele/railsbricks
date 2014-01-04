#!/usr/bin/env ruby

original_migration_file = ""
new_migration_file = ENV['HOME']+"/railsbricks/assets/user_model/devise/migration.rb"

# find file
Dir.foreach('db/migrate') do |file|
  if file.scan(/devise_create_users.rb/).size > 0
    original_migration_file = "db/migrate/#{file}"
  end
end

# display the name, useful when debugging
puts "--> migration file to update found:"
puts original_migration_file

# override migration file with new one
File.open(original_migration_file,"w") do |f|
  f.puts File.read(new_migration_file)
end


