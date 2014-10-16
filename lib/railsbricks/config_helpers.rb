require 'fileutils'
require 'json'

module ConfigHelpers

  CONFIG_PATH = ".rbricks"

  def self.create_config(app_dir, options = {})
    FileUtils::mkdir_p "#{app_dir}/#{CONFIG_PATH}"
    dup_options = options.dup
    dup_options[:email_config][:password] = "******"
    saved_options = dup_options.to_json

    File.open("#{app_dir}/#{CONFIG_PATH}/config", "w") { |f| f.write(saved_options)}

  end

  def self.load_config
    config_json = File.read("#{CONFIG_PATH}/config")
    JSON.parse(config_json)
  rescue
    options = {}
    options["rake_command"] = "rake"
    options
  end

end