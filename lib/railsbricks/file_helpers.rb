require "fileutils"
require_relative "errors"
module FileHelpers

  def self.replace_string(key,new_value,original_file,target_file = nil)
    target_file = original_file if target_file == nil
    text_update = File.read(original_file)
    text_update = text_update.gsub(key, new_value)

    File.open(target_file, "w") { |f| f.write(text_update) }

  rescue
    Errors.display_error "Something went wrong. The file '#{target_file}' couldn't be created and/or updated. Aborting app creation.", true
    abort

  end

  def self.override_file(source_file, target_file)
    FileUtils.rm(target_file)
    FileUtils.cp(source_file,target_file)

  rescue
    Errors.display_error "Couldn't override #{target_file}. Aborting app creation.", true
    abort
  end

  def self.add_to_file(target_file, text)
    content = File.read(target_file)

    File.open(target_file, "a") do |f|
      f.puts
      f.puts
      f.write(text)
      f.puts
    end
  rescue
    Errors.display_error "Couldn't write inside #{target_file}. Aborting app creation.", true
    abort
  end

end