require 'properties'
require 'pp'

class Thing
  include Properties

  property :p
  property :q
end

thing = Thing.new

# methods generated
thing.p # value of property foo
thing.p= 'value' # assign 'value' to foo
thing.p? # if a property has been set

# methods available
thing.properties # symbols of all properties

thing.dirty? # any propery been set?
thing.set_properties # symbols of all properties that have been set

# ...
p thing.dirty?
pp thing
puts
