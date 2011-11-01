require 'properties/class_methods'

module Properties

  def self.included(mod)
    mod.extend ClassMethods
  end

  def properties
    @properties ||= class_properties
  end

  def class_properties
    names = self.class.properties
    names.inject({}) do |h, name|
      h[name] = false
      h
    end
  end

end
