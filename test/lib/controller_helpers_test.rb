require "test_helper"
require "askfirst/controller_helpers"

class AskFirst::ControllerHelpersTest < Minitest::Test
  FakeRequest = Struct.new(:env, :user_agent)

  class FakeController
    include AskFirst::ControllerHelpers

    attr_reader :request

    def initialize(request)
      @request = request
    end
  end

  def build_controller(env = {}, user_agent: "Mozilla/5.0")
    FakeController.new(FakeRequest.new(env, user_agent))
  end

  def test_consent_given_returns_true_when_category_accepted
    controller = build_controller({"askfirst.consent" => { "analytics" => true }})

    assert_equal true, controller.consent_given?(:analytics)
  end

  def test_consent_given_returns_false_when_category_rejected
    controller = build_controller({"askfirst.consent" => { "analytics" => false }})

    assert_equal false, controller.consent_given?(:analytics)
  end

  def test_consent_given_returns_false_when_category_missing
    controller = build_controller({"askfirst.consent" => {}})

    assert_equal false, controller.consent_given?(:marketing)
  end

  def test_cookie_consent_tag_returns_html_for_web
    AskFirst.reset_configuration!
    controller = build_controller

    html = controller.cookie_consent_tag
    assert_includes html, "askfirst--consent"
    assert_includes html, "data-controller"
  ensure
    AskFirst.reset_configuration!
  end

  def test_cookie_consent_tag_returns_empty_for_turbo_native
    controller = build_controller({}, user_agent: "MyApp/1.0 Turbo Native iOS")

    html = controller.cookie_consent_tag
    assert_equal "", html
  end
end
