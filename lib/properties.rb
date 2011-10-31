require 'properties/class_methods'

module Properties

  # TODO some code organization
  # what dimension?
  # - aggregates vs singles
  # - normal properties vs required properties
  # - state vs other stuff

  def self.included(mod)
    mod.extend ClassMethods
  end

  def properties
    @properties ||= self.class.properties
  end

  def set_properties
    @set_properties ||= [] # TODO use a Set for faster lookup? is order important?
  end

  def get(name)
    ivar = :"@#{name}"

    if instance_variable_defined? ivar
      instance_variable_get ivar
    else
      nil # TODO great place to ask for default value
    end
  end

  def set(name, value)
    ivar = :"@#{name}"
    instance_variable_set ivar, value
    set_properties << name
  end

  def set?(name)
    set_properties.include? name
  end

  def dirty?
    set_properties.any?
  end

end
