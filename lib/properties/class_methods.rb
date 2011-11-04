module Properties

  module ClassMethods

    def property(name)
      property_names << name
      Property.new(name).define(self)
    end

    def property_names
      @property_names ||= []
    end

    class Property
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def define(cls)
        define_getter cls
        define_setter cls
        define_changed cls
      end

      def define_getter(cls)
        cls.send :attr_reader, name
      end

      def define_setter(cls)
        name = self.name
        cls.send :define_method, :"#{name}=" do |value|
          instance_variable_set :"@#{name}", value
          properties.changed! name
        end
      end

      def define_changed(cls)
        name = self.name
        cls.send :define_method, :"#{name}?" do
          properties.changed? name
        end
      end

    end

  end

end
