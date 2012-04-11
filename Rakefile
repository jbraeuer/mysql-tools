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

task :deb => [:package] do
  Dir.chdir "pkg" do
    system(%{fpm1.9.1 -s gem -t deb
	        --gem-gem=/usr/bin/gem1.9.1
 	    	--gem-package-prefix=rubygem19
            	--depends rubygems1.9.1 mysql-tools*.gem
	    }.delete("\n"))
  end
end

# - aruba (cucumber) tests
# ----------------------------------------
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty -x"
  t.fork = false
end
