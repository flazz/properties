require 'spec_helper'

describe InstanceMethods do
  let(:klass) do
    Class.new do
      extend ClassMethods
      include InstanceMethods
    end
  end

  let(:instance) { klass.new }
  let(:properties) { double 'properties' }
  let(:property) { double 'property' }

  before do
    instance.stub(:properties) { properties }
    properties.stub(:fetch) { property }
  end

  before { klass.property :some_property }

  it 'gets a property' do
    property.should_receive :get
    instance.some_property
  end

  it 'detects a set property' do
    property.should_receive :set?
    instance.some_property?
  end

  it 'sets a property' do
    property.should_receive :set
    instance.some_property = 'some value'
  end

end
