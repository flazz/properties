module Properties

  class Property
    attr_reader :value
    attr_writer :required

    def reset
      @value = nil
      @set = false
    end

    def set(name)
      @value = name
      @set = true
    end

    def set?
      @set
    end

    def required?
      @required
    end

    def satisfied?
      if required? then set? else true end
    end

  end

end
