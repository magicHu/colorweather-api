require './lib/weather'
spec = Gem::Specification.new do |s|
  s.name = 'colorweather-api'
  s.version = ColorWeather::VERSION
  s.summary = 'colorweather api'
  s.description = 'colorweather api'
  s.platform = Gem::Platform::RUBY
  s.authors = ["magichu"]
  s.email = ["huronghai2008@gmail.com"]
  s.date = ["2013-06-09"]
  s.required_ruby_version = '>= 2.0.0'
  s.homepage = 'https://github.com/magicHu/colorweather-api'
  s.files = Dir['lib/**/*']
end