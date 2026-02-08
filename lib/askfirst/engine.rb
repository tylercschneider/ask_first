module AskFirst
  class Engine < ::Rails::Engine
    isolate_namespace AskFirst

    initializer "askfirst.autoload" do |app|
      app.config.autoload_paths << root.join("app/models")
    end
  end
end
