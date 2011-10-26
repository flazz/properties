require 'properties'
require 'pp'

class Thing
  include Properties

  property :p
  property :q
  required_property :r
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

thing.requirements_met? # any required property not set?
thing.unset_required_properties # symbols of all required properties that are not set

p thing.dirty?
p thing.requirements_met?
pp thing
puts

thing.r = 'a required value'

p thing.dirty?
p thing.requirements_met?
pp thing
puts

thing.reset # unset all properties; i.e. dirty? will be false

p thing.dirty?
p thing.requirements_met?
pp thing
