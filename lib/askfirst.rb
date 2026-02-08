require "askfirst/version"
require "askfirst/configuration"
require "askfirst/engine" if defined?(Rails::Engine)

module AskFirst
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
