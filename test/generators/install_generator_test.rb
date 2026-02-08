require "test_helper"
require "rails/generators/test_case"
require "generators/askfirst/install/install_generator"

class AskFirst::InstallGeneratorTest < Rails::Generators::TestCase
  tests AskFirst::InstallGenerator
  destination File.expand_path("../../tmp/generators", __dir__)

  setup do
    prepare_destination
  end

  def test_creates_initializer
    run_generator

    assert_file "config/initializers/askfirst.rb" do |content|
      assert_match(/AskFirst\.configure/, content)
      assert_match(/cookie_name/, content)
    end
  end
end
