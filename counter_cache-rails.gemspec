$:.push File.expand_path('../lib', __FILE__)

require 'counter_cache_rails/version'

Gem::Specification.new do |s|
  s.name        = 'counter_cache-rails'
  s.version     = CounterCacheRails::VERSION
  s.author      = ['Shota Iguchi']
  s.email       = ['shota-iguchi@cookpad.com']
  s.homepage    = 'https://github.com/iguchi1124'
  s.summary     = 'ActiveRecord extentions for counter_cache.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 5.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'puma', '~> 3.0'
  s.add_development_dependency 'sass-rails', '~> 5.0'
  s.add_development_dependency 'uglifier', '>= 1.3.0'
  s.add_development_dependency 'jbuilder', '~> 2.5'
  s.add_development_dependency 'spring'
  s.add_development_dependency 'listen'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'redis-rails'
  s.add_development_dependency 'dalli'
end
