require "test_helper"
require_relative "../../app/controllers/askfirst/consents_controller"

class AskFirst::ConsentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    AskFirst.reset_configuration!
    AskFirst.configure { |c| c.log_consents = true }

    # Draw routes for test
    Rails.application.routes.draw do
      mount AskFirst::Engine, at: "/askfirst"
    end
  end

  def test_post_creates_consent_record
    assert_difference "AskFirst::ConsentRecord.count", 1 do
      post "/askfirst/consents", params: {
        consent: {
          visitor_id: "visitor-abc",
          categories: { analytics: true, marketing: false },
          policy_version: "1.0"
        }
      }, as: :json
    end

    assert_response :created

    record = AskFirst::ConsentRecord.last
    assert_equal "visitor-abc", record.visitor_id
    assert_equal({ "analytics" => true, "marketing" => false }, record.categories)
    assert_equal "1.0", record.policy_version
  end
end
