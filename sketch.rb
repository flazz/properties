require 'rubygems'
require 'ruby-debug'

require 'properties'
require 'pp'

class Klass
  extend Properties::ClassMethods
  include Properties::InstanceMethods

  property :p
  property :Fox
end

o = Klass.new

o.p # value of property p
o.p = :v # assign :v to property p
o.p? # true if p has been set, otherwise false
o.dirty? # true if any property has been set

pp o.properties
o.reset # reset all properties
