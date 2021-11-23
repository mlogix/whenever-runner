
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "whenever/runner/version"

Gem::Specification.new do |spec|
  spec.name          = "whenever-runner"
  spec.version       = Whenever::Runner::VERSION
  spec.authors       = ["Mykhailo Odyniuk"]
  spec.email         = ["m.odyniuk@gmail.com"]

  spec.summary       = %q{Whenever self runner}
  spec.description   = %q{Whenever self runner}
  spec.homepage      = "https://github.com/mlogix/whenever-runner.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/mlogix/whenever-runner.git"
    spec.metadata["changelog_uri"] = "https://github.com/mlogix/whenever-runner/changelog.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "whenever", ">= 0.10.0"
  spec.add_dependency "daemons", ">= 1.2"
  spec.add_dependency "fugit", ">= 1.4"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
