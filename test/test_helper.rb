$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

ENV["RAILS_ENV"] = "test"
ENV["DATABASE_URL"] = "sqlite3::memory:"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"

require "ask_first"

# Minimal Rails application for testing
class TestApp < Rails::Application
  config.eager_load = false
  config.active_support.deprecation = :stderr
  config.secret_key_base = "test-secret-key-base-for-askfirst-gem"
  config.hosts.clear
end

Rails.application.initialize!

ActiveRecord::Schema.define do
  create_table :askfirst_consent_records, force: true do |t|
    t.string  :visitor_id, null: false
    t.json    :categories, null: false, default: {}
    t.string  :policy_version
    t.string  :ip_address
    t.string  :user_agent
    t.integer :user_id
    t.timestamps
  end
end

require "minitest/autorun"

# Require app code (not autoloaded outside full Rails)
require_relative "../app/models/ask_first/consent_record"
