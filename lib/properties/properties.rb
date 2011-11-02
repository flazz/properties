module Properties

  class Properties
    attr_reader :data

    def self.build(names)
      properties = new

      names.inject(properties.data) do |h, name|
        h[name] = false
        h
      end

      properties
    end

    def initialize
      @data = {}
    end

    def set_changed(name)
      data[name] = true
    end

    def changed?(name)
      data[name]
    end

    def names
      data.keys
    end

  end

end
