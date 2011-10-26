require 'forwardable'

module Properties

  module InstanceMethods

    def properties
      @properties ||= initial_properties
    end

    def initial_properties
      self.class.properties.clone
    end

    extend Forwardable
    def_delegators :properties,
      :dirty?,
      :dirty_properties,
      :reset,
      :satisfied?,
      :unsatisfied_properties
  end

end
