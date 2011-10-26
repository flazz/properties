require 'properties'

class Thing
  include Properties

  property :foo
  required_property :bar
end

thing = Thing.new

# methods generated
thing.foo # value of property foo
thing.foo= 'value' # assign 'value' to foo
thing.foo? # if a property has been set

# methods available
thing.properties # symbols of all properties

thing.dirty? # any propery been set?
thing.dirty_properties # symbols of all properties that have been set

thing.satisfied? # any required property not set?
thing.unsatisfied_properties # symbols of all required properties that are not set

thing.reset # unset all properties; i.e. dirty? will be false
