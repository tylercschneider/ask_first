require "test_helper"

class AskFirst::ConsentRecordTest < Minitest::Test
  def test_valid_with_required_attributes
    record = AskFirst::ConsentRecord.new(
      visitor_id: "visitor-123",
      categories: { analytics: true, marketing: false }
    )

    assert record.valid?
  end
end
