require "test_helper"
require "askfirst/configuration"

class AskFirst::ConfigurationTest < Minitest::Test
  def test_has_default_cookie_name
    config = AskFirst::Configuration.new
    assert_equal "af_consent", config.cookie_name
  end
end
