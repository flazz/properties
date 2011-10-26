require 'properties/property'
require 'properties/set'
require 'properties/class_methods'
require 'properties/instance_methods'

module Properties

  def self.included(klass)
    klass.extend ClassMethods
  end

  include InstanceMethods
end
