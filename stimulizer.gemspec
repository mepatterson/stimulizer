# frozen_string_literal: true

require_relative "lib/stimulizer/version"

Gem::Specification.new do |spec|
  spec.name = "stimulizer"
  spec.version = Stimulizer::VERSION
  spec.authors = ["Matt E Patterson"]
  spec.email = ["mattp@digimonkey.com"]

  spec.summary = "Stimulizer provides convenience methods for working with StimulusJS in views, templates, and components."
  spec.homepage = "https://github.com/mepatterson/stimulizer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mepatterson/stimulizer"
  spec.metadata["changelog_uri"] = "https://github.com/mepatterson/stimulizer/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dry-configurable", ">= 0.16.1"
  spec.add_dependency "lucky_case", ">= 1.1.0"
  spec.add_dependency "activesupport"
  
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
