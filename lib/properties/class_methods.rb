module Properties

  module ClassMethods

    def property(name)
      properties << name

      attr_accessor name

      define_method(:"#{name}?") do
        send(name.to_sym) ? true : false
      end

    end

    def properties
      @properties ||= []
    end

  end

end
