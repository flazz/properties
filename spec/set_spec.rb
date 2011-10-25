require 'spec_helper'

describe Properties::Set do
  let(:set) { Properties::Set.new }

  context 'adds' do

    context 'properties' do
      subject { set }
      before { subject.add :some_property }
      it { should include :some_property }
    end

    context 'required properties' do
      subject { set }
      before { subject.add :some_required_property, true }
      it { should include :some_required_property }

      it 'are required' do
        subject.fetch(:some_required_property).should be_required
      end

    end

  end

  context 'detects' do

    context 'dirty properties' do
      subject { set }
      before { set.add :some_property }

      context 'with no set properties' do
        it { should_not be_dirty }
      end

      context 'with a set property' do
        before { set.fetch(:some_property).set :some_value }
        it { should be_dirty }
      end

    end

    context 'satisaction' do
      before { set.add :some_required_property, true }
      subject { set }

      context 'with an unset property' do
        it { should_not be_satisfied }
      end

      context 'with a set property' do
        before { set.fetch(:some_required_property).set :some_value }
        it { should be_satisfied }
      end
    end

  end

  context 'resets properties' do
    subject { set }

    before do
      set.add :some_property
      set.fetch(:some_property).set :some_value
    end

    before { set.reset }

    it { should_not be_dirty }
  end

end
