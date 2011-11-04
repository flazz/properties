module Properties

  class Properties

    def self.build(names)
      properties = new

      names.each do |name|
        properties[name] = false
      end

      properties
    end

    def initialize
      @data = {}
    end

    def [](name)
      @data[name]
    end

    def []=(name, value)
      @data[name] = value
    end

    def changed!(name, changed=true)
      self[name] = changed
    end

    def changed?(name)
      self[name]
    end

    def names
      @data.keys
    end

  end

end
