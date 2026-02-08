module AskFirst
  class Configuration
    attr_accessor :cookie_name, :cookie_expiry, :privacy_policy_url, :log_consents

    def initialize
      @cookie_name = "af_consent"
      @cookie_expiry = 365
      @privacy_policy_url = "/privacy"
      @log_consents = true
    end
  end
end
