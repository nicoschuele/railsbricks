module Version

  MAJOR = 3
  MINOR = 1
  PATCH = 5
  PRE = nil

  YEAR = "2015"
  MONTH = "01"
  DAY = "26"

  def self.to_s
    [MAJOR, MINOR, PATCH, PRE].compact.join(".")
  end

  def self.current
    to_s
  end

  def self.current_date
    "#{YEAR}-#{MONTH}-#{DAY}"
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
