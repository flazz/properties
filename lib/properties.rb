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
    @properties ||= initial_properties
  end

  def initial_properties
    self.class.properties
  end

  def set_properties
    @set_properties ||= [] # TODO use a Set for faster lookup? is order important?
  end

  def reset
    properties.each { |name| reset_property name }
  end

  def reset_property name
    i_var_name = :"@#{name}"
    instance_variable_set i_var_name, nil # TODO great place to get initial value
    set_properties.delete name
  end

  def get_property(name)
    ivar = :"@#{name}"

    if instance_variable_defined? ivar
      instance_variable_get ivar
    else
      nil # TODO great place to ask for default value
    end
  end

  def set_property(name, value)
    ivar = :"@#{name}"
    instance_variable_set ivar, value
    set_properties << name
  end

  def property_set?(name)
    set_properties.include? name
  end

  def dirty?
    set_properties.any?
  end

  def required_properties
    @required_properties ||= initial_required_properties
  end

  def initial_required_properties
    self.class.required_properties
  end

  def requirements_met?
    not unset_required_properties.any?
  end

  def unset_required_properties
    required_properties - set_properties
  end

end
