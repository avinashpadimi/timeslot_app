source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Use jsonapi-serializer for response json serialization
gem 'jsonapi-serializer', '~> 2.1'
# Use PostgreSQL for the databse
gem 'pg', '~> 1.2'

group :development, :test do
  # I personally prefer using pry, feel free to use a different debugger
  gem 'pry-byebug'
  # Use RSpec for testing
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 4.0'
  # Use factories to create data for tests
  gem 'factory_bot_rails'
  # Use faker to create random data for factories
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
