require 'test_helper'

module Vedeu

  module Views

  	describe View do

      let(:described)  { Vedeu::Views::View }
      let(:instance)   { described.new(attributes) }
      let(:attributes) {
        {
          name: _name,
        }
      }
      let(:_name)      { 'Vedeu::Views::View' }

      describe 'accessors' do
        it { instance.must_respond_to(:attributes) }
        it { instance.must_respond_to(:client) }
        it { instance.must_respond_to(:client=) }
        it { instance.must_respond_to(:name) }
        it { instance.must_respond_to(:name=) }
        it { instance.must_respond_to(:parent) }
        it { instance.must_respond_to(:parent=) }
        it { instance.must_respond_to(:lines=) }
        it { instance.must_respond_to(:zindex) }
        it { instance.must_respond_to(:zindex=) }
      end

      describe '#add' do
        let(:child) {}

        subject { instance.add(child) }

        # @todo Add more tests.
        # it { skip }
      end

      describe '#value' do
        subject { instance.value }

        # @todo Add more tests.
        # it { skip }
      end

      describe '#render' do
        subject { instance.render }

        context 'when the view is not visible' do
          it { subject.must_equal([]) }
        end

        context 'when the view is visible' do
          # @todo Add more tests.
          # it { skip }
        end
      end

      describe '#store_immediate' do
        subject { instance.store_immediate }

        it { subject.must_be_instance_of(described) }
      end

      describe '#store_deferred' do
        subject { instance.store_deferred }

        it { subject.must_be_instance_of(described) }

        context 'when the name is not defined' do
          let(:_name) {}

          it { proc { subject }.must_raise(Vedeu::InvalidSyntax) }
        end
      end

      describe '#visible?' do
        # @todo Add more tests.
        # it { skip }
      end

  	end # View

  end # Views

end # Vedeu
