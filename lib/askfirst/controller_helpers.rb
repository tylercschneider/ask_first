require "erb"

module AskFirst
  module ControllerHelpers
    TURBO_NATIVE_PATTERN = /Turbo Native/i

    def consent_given?(category)
      consent = request.env["askfirst.consent"] || {}
      consent[category.to_s] == true
    end

    def cookie_consent_tag
      return "".html_safe if turbo_native_request?

      config = AskFirst.configuration
      config_json = consent_config_json(config)

      (%(<div data-controller="askfirst--consent" ) +
        %(data-askfirst--consent-config-value="#{ERB::Util.html_escape(config_json)}" ) +
        %(data-askfirst--consent-endpoint-value="/askfirst/consents"></div>)).html_safe
    end

    private

    def turbo_native_request?
      request.user_agent.to_s.match?(TURBO_NATIVE_PATTERN)
    end

    def consent_config_json(config)
      categories = config.categories.transform_values do |cat|
        { title: cat.title, description: cat.description, required: cat.required }
      end

      {
        cookie_name: config.cookie_name,
        cookie_expiry: config.cookie_expiry,
        privacy_policy_url: config.privacy_policy_url,
        categories: categories
      }.to_json
    end
  end
end
