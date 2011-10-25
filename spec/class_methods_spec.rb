require 'spec_helper'

describe ClassMethods do
  let(:klass) { Class.new }
  before { klass.extend ClassMethods }

  context 'declare a property' do
    before { klass.property :some_property }
    subject { klass.properties }
    it { should include :some_property }

    context 'a required property' do
      before { klass.required_property :some_required_property }
      it { should include :some_required_property }

      describe 'the property' do
        subject { klass.properties.fetch :some_required_property }
        it { should be_required }
      end

    end

  end

end
