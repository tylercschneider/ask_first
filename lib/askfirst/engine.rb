require "askfirst/middleware"
require "askfirst/controller_helpers"

module AskFirst
  class Engine < ::Rails::Engine
    isolate_namespace AskFirst

    initializer "askfirst.autoload" do |app|
      app.config.autoload_paths << root.join("app/models")
    end

    initializer "askfirst.middleware" do |app|
      app.middleware.insert_before ActionDispatch::Cookies, AskFirst::Middleware
    end

    initializer "askfirst.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include AskFirst::ControllerHelpers
      end
      ActiveSupport.on_load(:action_view) do
        include AskFirst::ControllerHelpers
      end
    end
  end
end
