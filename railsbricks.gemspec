require "./lib/railsbricks/version"

Gem::Specification.new do |s|
  s.name        = 'railsbricks'
  s.version     = Version.current
  s.executables << 'rbricks'
  s.date        = Version.current_date
  s.summary     = "gem summary"
  s.description = "gem description"
  s.authors     = ["Nico Schuele"]
  s.email       = 'nicoschuele@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'http://www.railsbricks.net'
  s.license     = 'MIT'
end