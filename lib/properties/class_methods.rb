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
      define_getter name
      define_setter name
      define_detector name
    end

    def define_getter(name)
      define_method(name) do
        i_var_name = :"@#{name}"
        if instance_variable_defined? i_var_name
          instance_variable_get i_var_name
        else
          nil # TODO great place to ask for default value
        end
      end
    end

    def define_setter(name)
      define_method("#{name}=") { |value| set_property name, value }
    end

    def define_detector(name)
      define_method("#{name}?") { property_set? name }
    end

    def properties
      @properties ||= [] # TODO use a Set for faster lookup? is order important?
    end

    def required_properties
      @required_properties ||= [] # TODO use a Set for faster lookup? is order important?
    end

  end

end
