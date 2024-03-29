Gem::Specification.new do |spec|
  spec.name = %q{ona}
  spec.version = "1.0.3"
  spec.date = Time.now.strftime("%Y-%m-%d")
  spec.summary = %q{ona - utility to build shell tools}
  spec.author = 'Kazuyoshi Tlacaelel'
  spec.homepage = 'https://github.com/ktlacaelel/ona'
  spec.email = 'kazu.dev@gmail.com'
  spec.license = 'MIT'
  spec.require_paths = ["lib"]
  spec.bindir = 'bin'
  spec.add_runtime_dependency 'isna', '0.0.4'
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
