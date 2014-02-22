require 'net/http'
require 'uri'

module Version

  MAJOR = 2
  MINOR = 0
  PATCH = 3
  PRE = nil

  YEAR = "2014"
  MONTH = "02"
  DAY = "01"

  VERSION_REMOTE_FILE = "http://assets.nicoschuele.com/rbr-version.txt"
  INFO_REMOTE_FILE = "http://assets.nicoschuele.com/rbr-info.txt"

  def self.to_s
    [MAJOR, MINOR, PATCH, PRE].compact.join(".")
  end

  def self.current
    to_s
  end

  def self.current_date
    "#{YEAR}-#{MONTH}-#{DAY}"
  end

  def self.check_latest(remote_version = nil)
    if remote_version
      latest_version = remote_version
    else
      uri = URI.parse("#{VERSION_REMOTE_FILE}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      latest_version = response.body
    end

    diff_msg = "The latest version of RailsBricks is v#{latest_version}. You currently have RailsBricks v#{current}. You can update RailsBricks by running the following command: rbricks --update"
    same_msg = "The latest version of RailsBricks is v#{latest_version} and it matches the one installed on your system."

    latest_version == current ? same_msg : diff_msg

  end

  def self.check_info
    uri = URI.parse("#{INFO_REMOTE_FILE}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.body
  end

  def self.version_to_h(version)
    version_array = version.split(/\./)
    version_hash = {}
    version_hash[:major] = version_array[0]
    version_hash[:minor] = version_array[1]
    version_hash[:patch] = version_array[2]
    version_hash[:pre] = version_array[3]
    version_hash

  end

end