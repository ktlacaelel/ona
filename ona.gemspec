Gem::Specification.new do |spec|
  spec.name = %q{ona}
  spec.version = "1.0.1"
  spec.date = %q{2023-07-29}
  spec.summary = %q{ona - utility to build shell tools}
  spec.author = 'Kazuyoshi Tlacaelel'
  spec.homepage = 'https://github.com/ktlacaelel/ona'
  spec.email = 'kazu.dev@gmail.com'
  spec.license = 'MIT'
  spec.require_paths = ["lib"]
  spec.bindir = 'bin'
  spec.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "bin/ona",
    "lib/ona.rb",
    "ona.gemspec"
  ]
  spec.executables << 'ona'
end
