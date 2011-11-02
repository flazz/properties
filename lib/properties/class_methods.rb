module Properties

  module ClassMethods

    class Definer
      attr_reader :mod
      attr_reader :name

      def initialize(mod, name)
        @mod = mod
        @name = name
      end

      def define
        # these are private in ruby, hence the send
        mod.send :attr_reader, name
        mod.send :define_method, :"#{name}=", &setter
        mod.send :define_method, :"#{name}?", &truther
      end

      def truther
        name = self.name # ruby wont do instance scope in lambdas
        proc { send(name.to_sym) ? true : false }
      end

      def setter
        name = self.name # ruby wont do instance scope in lambdas
        proc do |value|
          instance_variable_set :"@#{name}", value
          properties.set_changed name
        end
      end

    end

    def property(name)
      properties << name
      Definer.new(self, name).define
    end

    def properties
      @properties ||= []
    end

  end

end
