require "test_helper"
require "ask_first/middleware"
require "rack"

class AskFirst::MiddlewareTest < Minitest::Test
  def setup
    AskFirst.reset_configuration!
    @app = ->(env) { [200, {}, [env["ask_first.consent"].to_s]] }
  end

  def test_parses_consent_cookie_into_env
    cookie_value = '{"analytics":true,"marketing":false}'
    env = Rack::MockRequest.env_for("/", "HTTP_COOKIE" => "af_consent=#{Rack::Utils.escape(cookie_value)}")

    middleware = AskFirst::Middleware.new(@app)
    status, _headers, _body = middleware.call(env)

    assert_equal 200, status
    assert_equal({ "analytics" => true, "marketing" => false }, env["ask_first.consent"])
  end

  def test_returns_empty_hash_when_no_cookie
    env = Rack::MockRequest.env_for("/")

    middleware = AskFirst::Middleware.new(@app)
    middleware.call(env)

    assert_equal({}, env["ask_first.consent"])
  end

  def test_gpc_header_overrides_non_required_categories_to_false
    cookie_value = '{"necessary":true,"analytics":true,"marketing":true}'
    env = Rack::MockRequest.env_for(
      "/",
      "HTTP_COOKIE" => "af_consent=#{Rack::Utils.escape(cookie_value)}",
      "HTTP_SEC_GPC" => "1"
    )

    AskFirst.configure do |config|
      config.category(:necessary) { |c| c.required = true }
      config.category(:analytics) { |c| c.title = "Analytics" }
      config.category(:marketing) { |c| c.title = "Marketing" }
    end

    middleware = AskFirst::Middleware.new(@app)
    middleware.call(env)

    consent = env["ask_first.consent"]
    assert_equal true, consent["necessary"]
    assert_equal false, consent["analytics"]
    assert_equal false, consent["marketing"]
  end
end
