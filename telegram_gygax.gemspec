lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "telegram_gygax/version"

Gem::Specification.new do |spec|
  spec.name          = "telegram_gygax"
  spec.version       = TelegramGygax::VERSION
  spec.authors       = ["Cristobal Galleguillos Katz"]
  spec.email         = ["cgallegu@gmail.com"]

  spec.summary       = %q{An interactive fiction game.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/cgallegu/telegram_gygax_DO_NOT_PUBLISH"

  spec.metadata["allowed_push_host"] = "NONE"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "telegram-bot-ruby", "~> 0.11.0"
end
