require 'test_helper'

module Vedeu

  module DSL

    describe Line do

      describe '#initialize' do
        it 'returns an instance of itself' do
          Line.new.must_be_instance_of(Vedeu::DSL::Line)
        end
      end

      # describe '#stream' do
      #   it 'returns the value assigned' do
      #     line  = Line.new
      #     attrs = line.stream do
      #       text 'Some text...'
      #     end

      #     attrs.must_equal(
      #       [
      #         {
      #           colour: {},
      #           style:  [],
      #           text:   "Some text...",
      #           width:  nil,
      #           align:  :left,
      #           parent: line.view_attributes,
      #         }
      #       ]
      #     )
      #   end

      #   it 'raises an exception if a block was not given' do
      #     skip('failing...')

      #     proc {
      #       Vedeu.view 'carbon' do
      #         line do
      #           stream
      #         end
      #       end
      #     }.must_raise(InvalidSyntax)
      #   end
      # end

      # describe '#text' do
      #   it 'returns an Array' do
      #     Line.new.text('Some text...').must_be_instance_of(Array)
      #   end

      #   it 'returns an array containing all streams defined for the line' do
      #     Line.new.text('Some text...').first.text.must_equal('Some text...')
      #   end
      # end

    end # Line

  end # DSL

end # Vedeu