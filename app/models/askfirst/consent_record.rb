module AskFirst
  class ConsentRecord < ActiveRecord::Base
    self.table_name = "askfirst_consent_records"

    validates :visitor_id, presence: true
    validates :categories, presence: true
  end
end
