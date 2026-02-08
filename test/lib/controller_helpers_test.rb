require "test_helper"
require "askfirst/controller_helpers"

class AskFirst::ControllerHelpersTest < Minitest::Test
  # Fake controller-like object with a request env
  class FakeController
    include AskFirst::ControllerHelpers

    attr_reader :request

    def initialize(env)
      @request = Struct.new(:env).new(env)
    end
  end

  def test_consent_given_returns_true_when_category_accepted
    controller = FakeController.new("askfirst.consent" => { "analytics" => true })

    assert_equal true, controller.consent_given?(:analytics)
  end

  def test_consent_given_returns_false_when_category_rejected
    controller = FakeController.new("askfirst.consent" => { "analytics" => false })

    assert_equal false, controller.consent_given?(:analytics)
  end

  def test_consent_given_returns_false_when_category_missing
    controller = FakeController.new("askfirst.consent" => {})

    assert_equal false, controller.consent_given?(:marketing)
  end
end
