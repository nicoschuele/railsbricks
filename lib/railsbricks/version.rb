module Version

  MAJOR = 3
  MINOR = 0
  PATCH = 2
  PRE = nil
  
  YEAR = "2014"
  MONTH = "11"
  DAY = "14"

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