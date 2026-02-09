require "ask_first/middleware"
require "ask_first/controller_helpers"

module AskFirst
  class Engine < ::Rails::Engine
    isolate_namespace AskFirst

    initializer "ask_first.middleware" do |app|
      app.middleware.insert_before ActionDispatch::Cookies, AskFirst::Middleware
    end

    initializer "ask_first.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include AskFirst::ControllerHelpers
      end
      ActiveSupport.on_load(:action_view) do
        include AskFirst::ControllerHelpers
      end
    end
  end
end
