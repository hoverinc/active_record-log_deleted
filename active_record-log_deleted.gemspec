
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record/log_deleted/version"

Gem::Specification.new do |spec|
  spec.name          = "active_record-log_deleted"
  spec.version       = ActiveRecord::LogDeleted::VERSION
  spec.authors       = ["matthew fong"]
  spec.email         = ["matthew@hover.to"]

  spec.summary       = %q{ActiveRecord migration methods for logging deleted records}
  spec.description   = %q{ActiveRecord migration methods for logging deleted records}
  spec.homepage      = "https://github.com/hoverinc/active_record-log_deleted"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
