# -*- encoding: utf-8; mode: ruby -*-

require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubygems'
require 'rubygems/package_task'
require 'cucumber'
require 'cucumber/rake/task'

# RSpec tasks
# ----------------------------------------
task :default => :rspec
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.rspec_opts = [ '--format documentation', '--color' ]
end

# - clean removes pkg dir
# - pkg task calls clean
# ----------------------------------------
CLEAN << "pkg"
task :pkg => [:clean]

# - pkg, gem, package task
# ----------------------------------------
spec = eval(File.read('mysql-tools.gemspec'))
spec.version = IO.read("VERSION").strip
Gem::PackageTask.new(spec) do |pkg|
end

# - aruba (cucumber) tests
# ----------------------------------------
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty -x"
  t.fork = false
end
