module Properties

  module ClassMethods

    def property(name)
      properties << name
      define_truther name
      define_setter name
      define_getter name
    end

    def define_getter(name)
      attr_reader name
    end

    def define_setter(name)
      define_method(:"#{name}=") do |value|
        instance_variable_set :"@#{name}", value
        properties.set_changed name
      end
    end

    def define_truther(name)
      define_method(:"#{name}?") { send(name.to_sym) ? true : false }
    end

    def properties
      @properties ||= []
    end

  end

end
