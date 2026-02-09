require "ask_first/version"
require "ask_first/configuration"
require "ask_first/engine" if defined?(Rails::Engine)

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
