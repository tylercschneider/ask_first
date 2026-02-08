require "test_helper"

class AskFirst::ConsentRecordTest < Minitest::Test
  def test_valid_with_required_attributes
    record = AskFirst::ConsentRecord.new(
      visitor_id: "visitor-123",
      categories: { analytics: true, marketing: false }
    )

    assert record.valid?
  end

  def test_invalid_without_visitor_id
    record = AskFirst::ConsentRecord.new(categories: { analytics: true })

    refute record.valid?
    assert_includes record.errors[:visitor_id], "can't be blank"
  end

  def test_latest_for_returns_most_recent_record
    AskFirst::ConsentRecord.create!(
      visitor_id: "v1",
      categories: { analytics: false },
      created_at: 1.day.ago
    )
    latest = AskFirst::ConsentRecord.create!(
      visitor_id: "v1",
      categories: { analytics: true }
    )

    assert_equal latest, AskFirst::ConsentRecord.latest_for("v1")
  end
end
