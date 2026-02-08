$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

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
require "askfirst"

# Require app models (not autoloaded outside Rails)
require_relative "../app/models/askfirst/consent_record"
