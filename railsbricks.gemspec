require "./lib/railsbricks/version"

Gem::Specification.new do |s|
  s.name        = 'railsbricks'
  s.version     = Version.current
  s.executables << 'rbricks'
  s.date        = Version.current_date
  s.summary     = "Create Rails apps. Faster."
  s.description = "RailsBricks enables you to create Rails apps much faster by automating mundane setup tasks and configuring useful common gems for you. "
  s.authors     = ["Nico Schuele"]
  s.email       = 'nicoschuele@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'http://www.railsbricks.net'
  s.license     = 'GNU GPL-3'
end
