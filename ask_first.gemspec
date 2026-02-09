require_relative "lib/ask_first/version"

Gem::Specification.new do |spec|
  spec.name        = "ask_first"
  spec.version     = AskFirst::VERSION
  spec.authors     = ["WYN"]
  spec.email       = ["dev@wyn.co"]
  spec.homepage    = "https://github.com/tylercschneider/ask_first"
  spec.summary     = "Cookie consent management for Rails"
  spec.description = "A Rails engine wrapping orestbida/cookieconsent v3 with server-side consent logging, helpers, and middleware for GDPR/CCPA compliance."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib,vendor}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1"
end
