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

    def changed!(name)
      self[name] = true
    end

    def changed?(name)
      self[name]
    end

    def names
      @data.keys
    end

  end

end
