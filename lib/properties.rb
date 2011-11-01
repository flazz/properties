require 'properties/class_methods'

module Properties

  def self.included(mod)
    mod.extend ClassMethods
  end

  def properties
    self.class.properties
  end

end
