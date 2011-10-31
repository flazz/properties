require 'properties'
require 'pp'

class Thing
  include Properties

  property :p
  property :q
end

thing = Thing.new

thing.properties # list of properties

# no: thing.property_names # list of proporty names (symbols)
# or,
thing.properties.names

thing.p # value of @p
thing.p = 'value' # assign 'value' to @p, set 'changed' indicator
thing.p? # true, if not truthy

# later
# no: thing.changed_p? # true if p was changed, eg: changed? :p

# remove, needs to be in some other concern (probably implemented as a module)
# no, not needed now. design path accounts for this
# thing.dirty? # any propery been set?

# no: thing.set_properties # symbols of all properties that have been set
# or,
thing.properties.changed # later, returns names
thing.properties.changed? # later returns true if any changes
thing.properties.changes # later, returns previous and current, indexed by name

thing.properties[:p].changed?

# do this last-ish
thing.properties[:p].value # calls thing#@p or thing#p
thing.properties[:p].value = 'foo' # calls thing#p=

# future
thing.properties[:p].changes # [previous, current]
thing.properties[:p].previous

# far future
# consider CQRS and replaying a changes queue. there are similarities here

# - - -

properties = Properties.new self # in the class?

class Properties
  def self.build(object)
    properties = Properties.new object
    properties.define_properties # look for things declared with the 'property' macro, and do meta stuff
  end
end


# - - -

property :foo

# need properties in class
# also need it in instance (for tracking)

def property(name) # class method in module
end



# - - -

# given: getters and setters and nil? convenience
# properties: knows that something was changed
# tracked_properties: previous values


# - - -

module Properties
  class Properties
    # list of property instances
    def changed?
      # true if any property.changed? == true
    end
  end
  
  class Property
    def changed?
      # true if was changed
    end

    def value
    end
  end
end

module Properties::Tracked
  class Properties
    # list of tracked properties
    
    def changes
      # return arrays of changes index by property names
    end
  end
  
  class Property < Properties::Properties
    def changed?
      # true has previous value
    end
    
    def previous_value

    end
  end
end