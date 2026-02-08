module AskFirst
  class Configuration
    attr_accessor :cookie_name

    def initialize
      @cookie_name = "af_consent"
    end
  end
end
