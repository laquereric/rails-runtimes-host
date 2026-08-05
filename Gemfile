# frozen_string_literal: true

source "https://rubygems.org"

ruby ">= 3.1"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.5"
gem "puma", ">= 6.0"
gem "bcrypt", "~> 3.1"
gem "bootsnap", require: false
gem "dotenv-rails", groups: %i[development test]
gem "rails-runtimes", path: ENV.fetch("RAILS_RUNTIMES_PATH", "../rails-runtimes")

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0"
end
