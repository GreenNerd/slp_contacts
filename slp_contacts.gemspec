$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'slp_contacts/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'slp_contacts'
  s.version     = SlpContacts::VERSION
  s.authors     = ['fahchen']
  s.email       = ['dev.fah@gmail.com']
  s.homepage    = 'https://github.com/fahchen/slp_contacts'
  s.summary     = 'Skylark Contacts App'
  s.description = 'The Contacts App of Skylark project.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'coffee-rails', '~> 4.0'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'slim-rails', '~> 3.0'

  s.add_development_dependency 'pg'
end
