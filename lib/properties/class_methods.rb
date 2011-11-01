module Properties

  module ClassMethods

    def property(name)
      properties << name

      attr_reader name

      define_method(:"#{name}=") do |value|
        properties[name] = true
        ivar = :"@#{name}"
        instance_variable_set ivar, value
      end

      define_method(:"#{name}?") do
        send(name.to_sym) ? true : false
      end

    end

    def properties
      @properties ||= []
    end

  end

end
