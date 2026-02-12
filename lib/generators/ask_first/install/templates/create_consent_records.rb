class CreateAskfirstConsentRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :askfirst_consent_records do |t|
      t.string  :visitor_id, null: false
      t.json    :categories, null: false, default: {}
      t.string  :policy_version
      t.string  :ip_address
      t.string  :user_agent
      t.references :user, null: true, foreign_key: true
      t.timestamps
    end

    add_index :askfirst_consent_records, :visitor_id
  end
end
