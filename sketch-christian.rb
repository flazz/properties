require 'set'

module Metaclass
  def self.get subject
    (class << subject; self; end)
  end

  def self.define_method subject, name, &block
    Metaclass.get(subject).send :define_method, name, &block
  end

  def self.include subject, mod
    Metaclass.get(subject).send :include, mod
  end
end

module Property
  def self.helper_methods_module name
    mod = Module.new 

    mod.send(:define_method, name) do
      get_property(name) 
    end

    mod.send(:define_method, "#{name}=") do |value|
      set_property name, value
    end

    mod.send(:define_method, "#{name}?") do
      property_set? name 
    end

    mod
  end

  def self.define klass, name
    klass.extend ClassMethods unless klass.ancestors.include?(ClassMethods)
    klass.send :include, InstanceMethods unless klass.ancestors.include?(InstanceMethods)
    klass.send :include, helper_methods_module(name)
    klass.properties << name
  end

  module ClassMethods
    def properties
      @properties ||= Set.new
    end
  end

  module InstanceMethods
    def properties
      @properties ||= self.class.properties.dup 
    end

    def reset_properties!
      properties.each {|p| reset_property!(p)}
    end

    def dirty?
      properties.any? {|p| property_set?(p) }
    end

    def property_set? name
      instance_variable_defined? "@#{name}"
    end
    
    def reset_property! name
      remove_instance_variable "@#{name}" rescue nil
    end

    def set_property name, value
      instance_variable_set "@#{name}", value
    end

    def get_property name
      instance_variable_get "@#{name}"
    end
  end
end

describe "An object with properties" do

  let(:object) { Object.new }

  before do
    Property.define object.class, :foo
    Property.define object.class, :bar
  end

  describe "asking for the value of a property" do
    subject { lambda{ object.foo } }

    it "tells me the value of the instance variable used to store it" do
      object.should_receive(:instance_variable_get).with("@foo").and_return("Foo")
      subject.call.should == "Foo"
    end
  end

  describe "providing a value for a property" do
    subject { lambda { object.foo= "Foo" } }

    it "uses an instance variable of the same name to store the value" do
      object.should_receive(:instance_variable_set).with("@foo","Foo")
      subject.call
    end
  end

  describe "asking if a value has been provided for a property" do
    subject { object.foo? }

    context "when I have provided a value" do
      before { object.foo= "Foo" }
      it { should be_true }
    end
    context "when I have not provided a value" do
      it { should be_false }
    end
  end

  describe "returning to a state where no values have been provided for properties" do
    subject { lambda { object.reset_properties!} }
    before do 
      object.foo = "Foo"
      object.bar = "Bar"
    end

    it "unsets all properties" do
      subject.call

      object.foo.should be_nil
      object.foo?.should be_false
      object.bar.should be_nil
      object.bar?.should be_false
    end
  end

  describe "asking whether or not values have been provided for any property" do
    subject { object.dirty? }

    context "when I have provided a value for a property" do
      before { object.foo = "Foo" }
      it { should be_true }
    end

    context "when I have not provided a value for any property" do
      it { should be_false }
    end

    context "when I have returned to a state where no values have been provided" do
      before { object.foo = "Foo"; object.reset_properties! }
      it { should be_false }
    end
  end

  describe "asking for a list of properties" do
    subject { object.properties }

    it "should have a representation of each property" do
      should include :foo
      should include :bar
    end
  end
end
