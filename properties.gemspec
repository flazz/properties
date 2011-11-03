# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "properties"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Autohost Austin"]
  s.email       = ["noreply@dcx.rackspace.com"]
  s.summary     = %q{functionality to allow objects to have type attributes}

  s.files        = Dir["lib/**/*"]
  #s.test_files   = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency('rake')
end
