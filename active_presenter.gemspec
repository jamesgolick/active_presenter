# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_presenter/version"

Gem::Specification.new do |s|
  s.name = "galetahub-active_presenter"
  s.version = ActivePresenter::VERSION.dup
  s.platform = Gem::Platform::RUBY 
  s.summary = "ActivePresenter is the presenter library"
  s.description = "ActivePresenter is the presenter library you already know! (...if you know ActiveRecord)"
  s.authors = ["James Golick", "Daniel Haran", "Igor Galeta"]
  s.email = "galeta.igor@gmail.com"
  s.rubyforge_project = "active_presenter"
  s.homepage = "https://github.com/galetahub/active_presenter"
  
  s.files = Dir["{app,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["{test}/**/*"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.require_paths = ["lib"]
  
  s.add_dependency("activerecord", ">= 0")
end
