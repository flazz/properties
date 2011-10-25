module Properties

  # TODO should this compose or inherit?
  #
  # this is specialized queries on a hash
  # does not break liskov
  # is a data structure
  #
  # TODO possibly rename this Binding?
  #
  # --franco
  class Set < Hash

    def self.copy set
      set.inject(new) do |new_set, (name, prop)|
        new_set[name] = prop.dup
        new_set
      end
    end

    def add(name, required=false)
      prop = Property.new
      prop.required = required
      store name, prop
    end

    def dirty?
      dirty.any?
    end

    def dirty
      values.select &:set?
    end

    def satisfied?
      values.all? &:satisfied?
    end

    def reset
      values.each &:reset
    end

  end

end
