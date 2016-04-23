source 'https://rubygems.org'

ruby '1.9.3'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

gem 'rails',    '~> 3.2.0'
gem 'firebase', '~> 0.1.4'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'nanoc', '~> 3.6.3'
gem 'nanoc-cachebuster', :git => 'git://github.com/keevee/nanoc-cachebuster.git'
gem 'w3c_validators'

# newer nokogiri versions give: Incompatible library version: nokogiri.bundle requires version 11.0.0 or later, but libxml2.2.dylib provides version 10.0.0
gem 'nokogiri', '~> 1.4.7'

gem 'pg'
gem 'heroku-api'

group :development do
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails', '~> 2.10.1'
  gem 'factory_girl_rails'
  gem 'debugger'
end

gem 'slim'
gem 'aws-sdk'
gem 'vfs', :git => 'git://github.com/momolog/vfs.git'
gem 'vos', :git => 'git://github.com/momolog/vos.git'
gem 'net-ssh', '~> 2.9.1'
gem 'net-sftp'

# filters etc
gem 'maruku'
gem 'kramdown',   '~>0.13'
gem 'deadweight', '~>0.2'
gem 'rainpress',  '~>1.0'
gem 'typogruby',  '~>1.0'
gem 'jsmin',      '~>1.0'
gem 'rack',       '~>1.2'
gem 'adsf',       '~>1.0'
gem 'coffee-script'
gem 'sass',       '~>3'
gem 'haml'
gem 'mime-types'

group :production do
  gem 'rails_12factor'
end

gem 'bootstrap-sass', '~> 2.1.0.0'
gem 'sass-rails',     '~> 3.2.3'
gem 'bourbon',        '~> 2.1.1'
gem 'coffee-rails',   '~> 3.2.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platform => :ruby

gem 'uglifier', '>= 1.0.3'

# downgrade because of activeadmin incompatibility
# http://stackoverflow.com/questions/16844411/rails-active-admin-deployment-couldnt-find-file-jquery-ui
gem "jquery-rails", "< 3.0.0"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "devise", "~> 2.2"
gem "activeadmin", "~> 0.5.0"
