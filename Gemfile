# frozen_string_literal: true

source "https://rubygems.org"

ruby ">= 3.1"

gem "rails", "~> 8.0.2"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 6.0"
gem "bcrypt", "~> 3.1"
gem "bootsnap", require: false
gem "dotenv-rails", groups: %i[development test]
# Docker sets RAILS_RUNTIMES_PATH=/workspace/rails-runtimes at build time.

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0"
end

gem "rack-attack", "~> 6.7"

gem "rails-runtimes",
  git: "https://github.com/laquereric/rails-runtimes.git",
  ref: "private-browser-v1"
