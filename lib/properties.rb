require 'properties/class_methods'

module Properties

  def self.included(klass)
    klass.extend ClassMethods
  end

  def properties
    @properties ||= initial_properties
  end

  def initial_properties
    self.class.properties
  end

  def required_properties
    @required_properties ||= initial_required_properties
  end

  def initial_required_properties
    self.class.required_properties
  end

  def set_property(name, value)
    i_var_name = :"@#{name}"
    instance_variable_set i_var_name, value
    set_properties << name
  end

  def property_set?(name)
    set_properties.include? name
  end

  def set_properties
    @set_properties ||= [] # TODO use a Set for faster lookup? is order important?
  end

  def reset # TODO rename to unset?
    properties.each do |name|
      i_var_name = :"@#{name}"
      instance_variable_set i_var_name, nil # TODO great place to get initial value
    end

    @set_properties = nil
  end

  def required_properties_met?
    not required_properties_not_met.any?
  end

  def required_properties_not_met
    required_properties - set_properties
  end

  def dirty?
    set_properties.any?
  end

end
