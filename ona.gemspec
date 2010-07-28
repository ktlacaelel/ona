# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ona}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kazuyoshi tlacaelel"]
  s.date = %q{2010-07-27}
  s.default_executable = %q{ona}
  s.description = %q{Simple shell for deployment.}
  s.email = %q{kazu.dev@gmail.com}
  s.executables = ["ona"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/ona",
     "lib/ona.rb",
     "lib/ona_cli.rb",
     "lib/ona_server.rb",
     "lib/ona_stack.rb",
     "ona.gemspec",
     "test/helper.rb",
     "test/test_ona.rb"
  ]
  s.homepage = %q{http://github.com/ktlacaelel/ona}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ona -- Deployment symplified.}
  s.test_files = [
    "test/helper.rb",
     "test/test_ona.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
