module Properties

  module ClassMethods

    def property(name)
      properties << name
      define_property_methods(name)
    end

    def define_property_methods(name)
      define_method(name) { get_property name }
      define_method("#{name}=") { |value| set_property name, value }
      define_method("#{name}?") { property_set? name }
    end

    def required_property(name)
      property name
      required_properties << name
    end

    def properties
      @properties ||= [] # TODO use a Set for faster lookup? is order important?
      # TODO grab the properties from the superclass
    end

    def required_properties
      @required_properties ||= [] # TODO use a Set for faster lookup? is order important?
      # TODO grab the properties from the superclass
    end

  end

end
