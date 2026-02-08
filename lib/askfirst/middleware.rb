require "json"
require "rack/utils"

module AskFirst
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      cookies = Rack::Utils.parse_cookies(env)
      cookie_name = AskFirst.configuration.cookie_name
      raw = cookies[cookie_name]

      env["askfirst.consent"] = raw ? parse_consent(raw) : {}

      @app.call(env)
    end

    private

    def parse_consent(raw)
      JSON.parse(raw)
    rescue JSON::ParserError
      {}
    end
  end
end
