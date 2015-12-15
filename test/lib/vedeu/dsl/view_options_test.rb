require 'test_helper'

module Vedeu

  module DSL

    describe ViewOptions do

      let(:described) { Vedeu::DSL::ViewOptions }
      let(:instance)  { described.new(opts) }
      let(:opts)      {
        {
          align:  align,
          colour: colour,
          pad:    pad,
          style:  style,
        }
      }
      let(:align)  {}
      let(:colour) {}
      let(:pad)    {}
      let(:style)  {}

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }

        context 'when the opts are given' do
          it { instance.instance_variable_get('@opts').must_equal(opts) }
        end

        context 'when the opts are not given' do
          let(:opts) {}
          let(:expected) {
            {
              align:  :none,
              colour: nil,
              pad:    ' ',
              style:  nil,
            }
          }

          it { instance.instance_variable_get('@opts').must_equal(expected) }
        end
      end

      describe '#align' do
        subject { instance.align }

        context 'when there is no align option' do
          it { subject.must_equal(:none) }
        end

        context 'when there is an align option' do
          let(:align) { :center }

          it { subject.must_equal(:centre) }

          context 'when the align option is invalid' do
            let(:align) { :invalid }

            it { subject.must_equal(:none) }
          end
        end
      end

      describe '#colour' do
        subject { instance.colour }

        context 'when there are no colour options' do
          it { subject.must_equal(nil) }
        end

        context 'when there are colour options' do
          let(:colour) {
            {
              background: '#000088',
              foreground: '#ffff00',
            }
          }

          it {
            Vedeu::Colours::Colour.expects(:coerce).with(opts)
            subject
          }
          it { subject.must_be_instance_of(Vedeu::Colours::Colour) }
          it { subject.background.must_be_instance_of(Vedeu::Colours::Background) }
          it { subject.background.value.must_equal('#000088') }
          it { subject.foreground.must_be_instance_of(Vedeu::Colours::Foreground) }
          it { subject.foreground.value.must_equal('#ffff00') }
        end
      end

      describe '#options' do
        let(:expected) {
          {
            align:  :none,
            colour: nil,
            pad:    ' ',
            style:  nil,
          }
        }

        subject { instance.options }

        it { subject.must_be_instance_of(Hash) }
        it { subject.must_equal(expected) }
      end

      describe '#pad' do
        subject { instance.pad }

        context 'when the pad option is nil' do
          let(:pad) {}

          it { subject.must_equal(' ') }
        end

        context 'when the pad option is not a string' do
          let(:pad) { 44 }

          it { subject.must_equal(' ') }
        end

        context 'when the pad is a multi-character string' do
          let(:pad) { 'multi' }

          it { subject.must_equal('m') }
        end
      end

      describe '#style' do
        subject { instance.style }

        context 'when there are no style options' do
          it { subject.must_equal(nil) }
        end

        context 'when there are style options' do
          let(:style) { [:bold, :underline] }

          it {
            Vedeu::Presentation::Style.expects(:coerce).with(opts)
            subject
          }
          it { subject.must_be_instance_of(Vedeu::Presentation::Style) }
          it { subject.value.must_equal(style) }
        end
      end

    end # ViewOptions

  end # DSL

end # Vedeu
