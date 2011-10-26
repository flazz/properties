module Properties

  # TODO should this compose or inherit?
  #
  # this is specialized queries on a hash
  # does not break liskov
  # probably breaks demeter
  # is a data structure
  #
  # TODO possibly rename this Binding?
  #
  # --franco
  class Set < Hash

    def clone
      inject(self.class.new) do |set, (name, prop)|
        set[name] = prop.dup
        set
      end
    end

    def add(name, required=false)
      prop = Property.new
      prop.required = required
      store name, prop
    end

    def dirty?
      dirty_properties.any?
    end

    def dirty_properties
      values.select &:set?
    end

    def satisfied?
      not unsatisfied_properties.any?
    end

    def unsatisfied_properties
      values.reject &:satisfied?
    end

    def reset
      values.each &:reset
    end

  end

end
