require 'set'

module MetaClass
  def self.get subject
    (class << subject; self; end)
  end

  def self.ancestry subject
    meta = get(subject)
    ancestry = meta.ancestors.dup
    ancestry.unshift meta
    ancestry
  end
end

module Properties
  def self.define subject, name, helpers = true
    klass = subject.is_a?(Class) ? subject : MetaClass.get(subject)

    provide_extensions klass
    provide_inclusions klass
    provide_helpers klass, name if helpers

    subject.define_property name
  end

  def self.provide_extensions klass
    klass.extend ClassMethods 
  end

  def self.provide_inclusions klass
    klass.send(:include, InstanceMethods) 
  end

  def self.provide_helpers klass, name
    klass.send :include, helper_methods_module(name)
  end

  def self.helper_methods_module name
    mod = Module.new

    mod.send :define_method, name do
      get_property name
    end

    mod.send :define_method, "#{name}=" do |value|
      set_property name, value
    end

    mod.send :define_method, "#{name}_changed?" do
      property_changed? name
    end

    mod
  end

  module DSL
    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def property name
        Properties.define self, name
      end
    end
  end

  module ClassMethods
    def defined_properties
      @defined_properties ||= Set.new
    end

    def define_property name
      defined_properties << name
    end
  end

  module InstanceMethods
    # -- Defining 

    def define_property name
      defined_instance_properties << name
    end

    def defined_properties
      defined_instance_properties + inherited_property_definitions
    end

    def defined_instance_properties
      @defined_instance_properties ||= Set.new
    end

    def inherited_property_definitions
      ancestors = MetaClass.ancestry(self)
      ancestors.inject(Set.new) do |set, klass|
        set += klass.defined_properties if klass.respond_to?(:defined_properties)
        set
      end
    end

    def property_defined? name
      defined_properties.include? name
    end

    # -- Setting
    
    def set_property name, value
      ivar = "@#{name}"
      store_initial_property_value(name) unless property_changed?(name) 
      instance_variable_set ivar, value
      mark_property_changed name
    end

    # -- Initial Values
    
    def store_initial_property_value name
      set_initial_property_value name, get_property(name)
    end

    def set_initial_property_value name, value
      initial_property_values[name] = value
    end

    def initial_property_values
      @initial_property_values ||= {}
    end

    def initial_property_value name
      initial_property_values[name]
    end

    # -- Changes

    def changed_properties?
      changed_properties.any?
    end

    def property_changed? name
      changed_properties.include? name
    end

    def changed_properties
      @changed_properties ||= Set.new
    end

    def mark_property_changed name
      changed_properties << name
    end

    # -- Getting
   
    def get_property name
      ivar = "@#{name}"
      instance_variable_get ivar
    end

    # -- List
    
    def properties
      defined_properties.inject({}) do |props,name|
        props[name] = get_property(name)
        props
      end
    end

    # -- Resetting

    def reset_properties!
      defined_properties.each { |name| reset_property! name }
    end

    def reset_property! name
      restore_initial_property_value name
      mark_property_unchanged name
    end

    def restore_initial_property_value name
      value = initial_property_value(name)
      set_property name, value
    end

    def mark_property_unchanged name
      changed_properties.delete name
    end

  end
end

class Foo
  include Properties::DSL
  property :foo
end

class Bar < Foo
  property :bar
end

describe "An object with properties" do

  let(:object) { Bar.new }

  before do
    Properties.define object, :baz
    Properties.define MetaClass.get(object), :qux
  end

  describe "asking for the value of a property" do
    subject { lambda{ object.get_property :foo } }

    it "tells me the value of the instance variable used to store it" do
      object.should_receive(:instance_variable_get).with("@foo").and_return("Foo")
      subject.call.should == "Foo"
    end
  end

  describe "providing a value for a property" do
    subject { lambda { object.set_property :foo, "Bar" } }

    after { subject.call }

    it "uses an instance variable of the same name to store the value" do
      object.should_receive(:instance_variable_set).with("@foo", "Bar")
    end

    context "when no changes have been made" do
      it "stores the initial value" do
        object.should_receive(:set_initial_property_value).with(:foo, nil)
      end
    end

    context "when changes have been made" do
      before { object.set_property :foo, "Foo" }
      it "does not store the initial value" do
        object.should_not_receive(:set_initial_property_value)
      end
    end
  end

  describe "asking if a value has been provided for a property" do
    subject { object.property_changed? :foo }

    context "when I have provided a value" do
      before { object.set_property :foo, "Foo" }
      it { should be_true }
    end

    context "when I have not provided a value" do
      it { should be_false }
    end
  end

  describe "returning to a state where no values have been provided for properties" do
    subject { lambda { object.reset_properties! } }

    before do 
      object.set_property :foo, "Foo"
      object.set_property :bar, "Bar"
      object.set_property :baz, "Baz"
      object.set_property :qux, "Qux"
    end

    it "sets all properties to initial values" do
      object.should_receive(:restore_initial_property_value).with(:foo)
      object.should_receive(:restore_initial_property_value).with(:bar)
      object.should_receive(:restore_initial_property_value).with(:baz)
      object.should_receive(:restore_initial_property_value).with(:qux)
      subject.call
    end

    it "marks them as unchanged" do
      object.should_receive(:mark_property_unchanged).with(:foo)
      object.should_receive(:mark_property_unchanged).with(:bar)
      object.should_receive(:mark_property_unchanged).with(:baz)
      object.should_receive(:mark_property_unchanged).with(:qux)
      subject.call
    end
  end

  describe "asking whether or not values have been provided for any property" do
    subject { object.changed_properties? }

    context "when I have provided a value for a property" do
      before { object.set_property :foo, "Foo" }
      it { should be_true }
    end

    context "when I have not provided a value for any property" do
      it { should be_false }
    end

    context "when I have returned to a state where no values have been provided" do
      before { object.set_property :foo, "Foo"; object.reset_properties! }
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

