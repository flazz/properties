require 'forwardable'

module Properties

  module InstanceMethods

    def properties
      @properties ||= initial_properties
    end

    def initial_properties
      Set.copy self.class.properties
    end

    extend Forwardable
    def_delegators :properties, :dirty?, :reset, :satisfied?
  end

end
