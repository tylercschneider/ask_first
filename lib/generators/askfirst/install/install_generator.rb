require "rails/generators"
require "rails/generators/active_record"

module AskFirst
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    def copy_initializer
      template "initializer.rb", "config/initializers/askfirst.rb"
    end

    def copy_migration
      migration_template "create_consent_records.rb", "db/migrate/create_askfirst_consent_records.rb"
    end

    def print_instructions
      say ""
      say "AskFirst installed! Next steps:", :green
      say "  1. Run migrations: bin/rails db:migrate"
      say "  2. Mount the engine in config/routes.rb:"
      say "       mount AskFirst::Engine, at: '/askfirst'"
      say "  3. Add to your layout:"
      say "       <%= cookie_consent_tag %>"
      say ""
    end
  end
end
