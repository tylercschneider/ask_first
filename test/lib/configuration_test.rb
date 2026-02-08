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

  def test_registers_a_category
    @config.category(:analytics) do |c|
      c.title = "Analytics"
      c.description = "Help us understand usage."
      c.cookies = %w[_ga _gid]
    end

    cat = @config.categories[:analytics]
    assert_equal "Analytics", cat.title
    assert_equal "Help us understand usage.", cat.description
    assert_equal %w[_ga _gid], cat.cookies
    assert_equal false, cat.required
  end
end
