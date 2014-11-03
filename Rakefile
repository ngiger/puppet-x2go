require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec_helper'
require 'puppet-syntax/tasks/puppet-syntax'
require 'hiera'

# PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

desc "Run validate, syntax and spec_standalone"
task :test  => [ :validate, :syntax, :spec_standalone]
