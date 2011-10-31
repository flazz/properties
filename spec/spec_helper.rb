require 'rspec/mocks/standalone'

support_files = Dir["spec/support/**/*.rb"]
support_files.each {|f| require f}

require 'properties'
include Properties
