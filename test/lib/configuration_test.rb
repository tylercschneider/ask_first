require "test_helper"
require "askfirst/configuration"

class AskFirst::ConfigurationTest < Minitest::Test
  def setup
    @config = AskFirst::Configuration.new
  end

  def test_has_default_cookie_name
    assert_equal "af_consent", @config.cookie_name
  end

  def test_has_default_cookie_expiry
    assert_equal 365, @config.cookie_expiry
  end

  def test_has_default_privacy_policy_url
    assert_equal "/privacy", @config.privacy_policy_url
  end

  def test_has_default_log_consents
    assert_equal true, @config.log_consents
  end
end
