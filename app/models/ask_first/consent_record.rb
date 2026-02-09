module AskFirst
  class ConsentRecord < ActiveRecord::Base
    self.table_name = "askfirst_consent_records"

    validates :visitor_id, presence: true
    validates :categories, presence: true

    scope :latest_for, ->(visitor_id) {
      where(visitor_id: visitor_id).order(created_at: :desc).first
    }
  end
end
