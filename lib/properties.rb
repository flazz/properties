require 'properties/class_methods'
require 'properties/properties'

module Properties

  def self.included(mod)
    mod.extend ClassMethods
  end

  def properties
    @properties ||= Properties.build(self.class.properties)
  end

end
