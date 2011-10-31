module Properties

  module ClassMethods

    def property(name)
      properties << name
      define_property_methods(name)
    end

    def define_property_methods(name)
      define_method(name) { get name }
      define_method("#{name}=") { |value| set name, value }
      define_method("#{name}?") { set? name }
    end

    def properties
      @properties ||= [] # TODO use a Set for faster lookup? is order important?
      # TODO grab the properties from the superclass
    end

  end

end
