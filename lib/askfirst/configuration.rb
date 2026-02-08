module AskFirst
  class Configuration
    attr_accessor :cookie_name, :cookie_expiry, :privacy_policy_url, :log_consents
    attr_reader :categories

    def initialize
      @cookie_name = "af_consent"
      @cookie_expiry = 365
      @privacy_policy_url = "/privacy"
      @log_consents = true
      @categories = {}
    end

    def category(name)
      cat = Category.new(name)
      yield(cat) if block_given?
      @categories[name] = cat
    end
  end

  class Category
    attr_accessor :title, :description, :cookies, :required

    def initialize(name)
      @name = name
      @title = name.to_s.capitalize
      @description = ""
      @cookies = []
      @required = false
    end
  end
end
