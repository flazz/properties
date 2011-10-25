require 'spec_helper'

describe Property do
  let(:property) { Property.new }

  context 'assigns value' do
    let(:value) { 'some value' }
    before { property.set value }
    subject { property.value }
    it { should == value }
  end

  context 'resets value' do
    before { property.set 'some value' }
    before { property.reset }
    it { should_not be_set }
  end

  context 'detects' do
    subject { property }

    describe 'an unset value' do
      it { should_not be_set }
    end

    describe 'a set value' do
      before { subject.set 'some subject'}
      it { should be_set }
    end

    context 'required' do
      before { subject.required = true }
      it { should be_required }
    end

    context 'not required' do
      before { subject.required = false }
      it { should_not be_required }
    end

    context 'satisfied requirement' do
      before { subject.required = true }

      context 'unset' do
        it { should_not be_satisfied }
      end

      context 'set' do
        before { subject.set :some_value }
        it { should be_satisfied }
      end

    end

  end

end
