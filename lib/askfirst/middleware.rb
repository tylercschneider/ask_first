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

      consent = raw ? parse_consent(raw) : {}
      consent = apply_gpc(consent) if env["HTTP_SEC_GPC"] == "1"
      env["askfirst.consent"] = consent

      @app.call(env)
    end

    private

    def parse_consent(raw)
      JSON.parse(raw)
    rescue JSON::ParserError
      {}
    end

    def apply_gpc(consent)
      required_keys = AskFirst.configuration.categories
        .select { |_name, cat| cat.required }
        .keys
        .map(&:to_s)

      consent.each_with_object({}) do |(key, value), result|
        result[key] = required_keys.include?(key) ? value : false
      end
    end
  end
end
