require_relative 'lib/active_record/log_deleted/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record-log_deleted"
  spec.version       = ActiveRecord::LogDeleted::VERSION
  spec.authors       = ["matthew fong"]
  spec.email         = ["matthew@hover.to"]

  spec.summary       = %q{ActiveRecord migration methods for logging deleted records}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/hoverinc/active_record-log_deleted"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "combustion"
  spec.add_development_dependency "rspec-rails"

  spec.add_runtime_dependency "activerecord", ">= 5.2", "< 8.0"
  spec.add_runtime_dependency "pg"
end
