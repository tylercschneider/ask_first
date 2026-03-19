require "test_helper"
require "rails/generators/test_case"
require "generators/ask_first/install/install_generator"

class AskFirst::InstallGeneratorTest < Rails::Generators::TestCase
  tests AskFirst::InstallGenerator
  destination File.expand_path("../../tmp/generators", __dir__)

  setup do
    prepare_destination
    FileUtils.mkdir_p(File.join(destination_root, "config"))
    File.write(
      File.join(destination_root, "config/routes.rb"),
      "Rails.application.routes.draw do\nend\n"
    )
  end

  def test_creates_initializer
    run_generator

    assert_file "config/initializers/ask_first.rb" do |content|
      assert_match(/AskFirst\.configure/, content)
      assert_match(/cookie_name/, content)
    end
  end

  def test_creates_migration
    run_generator

    assert_migration "db/migrate/create_askfirst_consent_records.rb" do |content|
      assert_match(/create_table :askfirst_consent_records/, content)
      assert_match(/visitor_id/, content)
      assert_match(/categories/, content)
    end
  end

  def test_copies_stimulus_controller
    run_generator

    assert_file "app/javascript/controllers/ask_first/consent_controller.js" do |content|
      assert_match(/import.*Controller.*from.*@hotwired\/stimulus/, content)
      assert_match(/vanilla-cookieconsent/, content)
    end
  end

  def test_adds_mount_line_to_routes
    run_generator

    assert_file "config/routes.rb", /mount AskFirst::Engine, at: "\/consent"/
  end
end
