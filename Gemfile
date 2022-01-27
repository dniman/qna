source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'slim-rails'
gem 'devise'
gem 'jquery-rails'
gem 'aws-sdk-s3'
gem 'cocoon'
gem 'skim'
gem 'gon'
gem 'foundation-rails'
gem 'autoprefixer-rails'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'cancancan'
gem "doorkeeper", "~> 5.4"
gem "active_model_serializers", "~> 0.10.10"
gem 'oj'
gem "sidekiq", "~> 6.4"
gem "sinatra", require: false
gem "whenever", require: false
gem "mysql2"
gem "thinking-sphinx"
gem 'database_cleaner-active_record'
gem 'mimemagic', '0.3.10'
gem 'mini_racer'
gem 'unicorn'
gem 'redis-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'letter_opener'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'


  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem 'webdrivers', '~> 4.0'
  gem 'capybara', '>= 2.15'
  #gem 'selenium-webdriver'
  #gem 'chromedriver-helper'
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'rails-controller-testing'
  gem 'launchy'
  #gem 'rspec-instafail', require: false
  gem 'action-cable-testing'
  gem 'capybara-email'
  gem 'json-schema'
  gem 'json_matchers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

