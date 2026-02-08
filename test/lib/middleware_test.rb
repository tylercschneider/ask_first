require "test_helper"
require "askfirst/middleware"
require "rack"

class AskFirst::MiddlewareTest < Minitest::Test
  def setup
    AskFirst.reset_configuration!
    @app = ->(env) { [200, {}, [env["askfirst.consent"].to_s]] }
  end

  def test_parses_consent_cookie_into_env
    cookie_value = '{"analytics":true,"marketing":false}'
    env = Rack::MockRequest.env_for("/", "HTTP_COOKIE" => "af_consent=#{Rack::Utils.escape(cookie_value)}")

    middleware = AskFirst::Middleware.new(@app)
    status, _headers, _body = middleware.call(env)

    assert_equal 200, status
    assert_equal({ "analytics" => true, "marketing" => false }, env["askfirst.consent"])
  end
end
