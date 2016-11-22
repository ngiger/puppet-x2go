source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['>= 3.8']
gem 'puppet', puppetversion
gem 'metadata-json-lint'
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'
gem 'puppet-lint', '~> 2.0'

#gem 'puppet-syntax'
#gem 'hiera-puppet-helper'

gem 'json',      '<= 1.8'   if RUBY_VERSION < '2.0.0'
gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.0'
else
  # rubocop requires ruby >= 1.9
  gem 'rubocop'              if RUBY_VERSION >= '2.0.0'
  gem 'rubocop', '<= 0.41.2' if RUBY_VERSION < '2.0.0'
end

