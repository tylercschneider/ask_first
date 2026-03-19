require "rails/generators"
require "rails/generators/active_record"

module AskFirst
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    def mount_engine
      route 'mount AskFirst::Engine, at: "/consent"'
    end

    def copy_initializer
      template "initializer.rb", "config/initializers/ask_first.rb"
    end

    def copy_migration
      migration_template "create_consent_records.rb", "db/migrate/create_askfirst_consent_records.rb"
    end

    def pin_javascript
      return unless importmap?

      run "bin/importmap pin vanilla-cookieconsent"
    end

    def copy_stimulus_controller
      copy_file(
        File.expand_path("../../../../app/javascript/ask_first/consent_controller.js", __dir__),
        "app/javascript/controllers/ask_first/consent_controller.js"
      )
    end

    def print_instructions
      say ""
      say "AskFirst installed! Next steps:", :green
      say "  1. Run migrations: bin/rails db:migrate"
      say "  2. Add to your layout:"
      say "       <%= cookie_consent_tag %>"
      say ""
    end

    private

    def importmap?
      File.exist?(Rails.root.join("config/importmap.rb"))
    end
  end
end
