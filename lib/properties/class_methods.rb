module Properties

  module ClassMethods

    def property(name)
      property_names << name
      PropertyDefinition.new(self, name).define
    end

    def property_names
      @property_names ||= []
    end
    
    class PropertyDefinition
      attr_reader :cls
      attr_reader :name

      def initialize(cls, name)
        @cls = cls
        @name = name
      end

      def define
        define_getter
        define_setter
        define_truth
      end
      
      def define_getter
        cls.send :attr_reader, name
      end

      def define_setter
        name = self.name
        cls.send :define_method, :"#{name}=" do |value|
          instance_variable_set :"@#{name}", value
          properties.changed! name
        end
      end
      
      def define_truth
        name = self.name
        cls.send :define_method, :"#{name}?" do
          send(name.to_sym) ? true : false
        end
      end

    end

  end

end