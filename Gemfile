source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bcrypt"
gem "bootstrap-datepicker-rails"
gem "bootstrap-kaminari-views"
gem "bootstrap-sass", "3.3.7"
gem "bootstrap_progressbar"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "figaro"
gem "font-awesome-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails", "~> 4.3", ">= 4.3.1"
gem "kaminari"
gem "mysql2"
gem "puma", "~> 5.5"
gem "rails", "~> 5.1.6"
gem "sass-rails", "~> 5.0"
gem "sqlite3"
gem "time_difference", "~> 0.7.0"
gem "turbolinks", "~> 5"
gem "ransack"
gem "uglifier", ">= 1.3.0"
gem "carrierwave"
gem "mini_magick"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "ckeditor"


group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
