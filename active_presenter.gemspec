Gem::Specification.new do |s|
  s.name = %q{active_presenter}
  s.version = "1.3.0"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Golick and Daniel Haran"]
  s.date = %q{2010-06-28}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
     "LICENSE",
     "README",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "active_presenter.gemspec",
     "lib/active_presenter.rb",
     "lib/active_presenter/base.rb",
     "lib/active_presenter/version.rb",
     "lib/tasks/doc.rake",
     "lib/tasks/gem.rake",
     "test/test_helper.rb",
     "test/base_test.rb",
     "test/lint_test.rb"
 ]
  s.homepage = %q{http://github.com/jamesgolick/active_presenter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{The presenter library you already know.}
  s.test_files = [
    "test/base_test.rb",
    "test/lint_test.rb",
    "test/test_helper.rb"
  ]
  s.add_runtime_dependency(%q<activerecord>, [">= 0"])
end