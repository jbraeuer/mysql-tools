# -*- encoding: utf-8 -*-
# -*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name        = "mysql-tools"
  s.version     = "9999.9.9"
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ "Jens Braeuer" ]
  s.email       = [ "braeuer.jens@googlemail.com" ]
  s.homepage    = "https://github.com/jbraeuer/mysql-tools"
  s.summary     = "Backup/Restore/Obfuscate Mysql dumps"
  s.description = "Backup, Restore and Obfuscate database dumps."
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "gli"
  s.add_dependency "mysql2"
  s.add_dependency "my_obfuscate"
  s.add_dependency "erubis"

  s.add_development_dependency "aruba"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt Readme.md)
  s.executables  = ['mysql-tools', 'mysql-tools-test']
  s.require_path = 'lib'
end
