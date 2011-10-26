module Properties

  module ClassMethods

    def property(name)
      properties << name
      define_property_methods name
    end

    def required_property(name)
      property name
      required_properties << name
    end

    def define_property_methods(name)
      define_method(name) { instance_variable_get name }
      define_method("#{name}=") { |val| set_property name }
      define_method("#{name}?") { property_set? name }
    end

    def properties
      @properties ||= []
    end

    def required_properties
      @properties ||= []
    end

  end

end
