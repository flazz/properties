module Properties

  module ClassMethods

    def property(name)
      properties.add name
      define_property_methods name
    end

    def required_property(name)
      properties.add name, true
      define_property_methods name
    end

    def define_property_methods name
      define_method(name) { properties.fetch(name).get }
      define_method("#{name}?") { properties.fetch(name).set? }
      define_method("#{name}=") { |val| properties.fetch(name).set val }
    end

    def properties
      @properties ||= Set.new
    end

  end

end
