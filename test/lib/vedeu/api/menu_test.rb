require 'test_helper'

module Vedeu
  module API

    describe Menu do
      describe '.define' do
        it 'raises an exception if no block was given' do
          proc { Menu.define }.must_raise(InvalidSyntax)
        end

        it 'raises an exception if no name was specified for the menu' do
          proc { Menu.define { } }.must_raise(InvalidSyntax)
        end

        it 'adds the menu to the menus repository' do
          Menu.define do
            name  'elements'
            items [:sodium, :magnesium, :aluminium, :silicon]
          end

          Vedeu::Menus.registered.must_equal(['elements'])
        end

        it 'returns the API::Menu instance' do
          Menu.define do
            name 'elements'
          end.must_be_instance_of(API::Menu)
        end
      end

      describe '#initialize' do
        it 'returns an instance of itself' do
          Menu.new.must_be_instance_of(Menu)
        end
      end

      describe '#items' do
        it 'returns an instance of Vedeu::Menu' do
          menu = Menu.new
          menu.items.must_be_instance_of(Vedeu::Menu)
        end

        it 'assigns the instance of Vedeu::Menu to the attributes' do
          menu = Menu.new
          menu.items([:sodium, :magnesium, :aluminium, :silicon])
          menu.attributes[:items].must_be_instance_of(Vedeu::Menu)
        end
      end

      describe '#name' do
        it 'returns the name of the menu' do
          menu = Menu.new
          menu.name('elements').must_equal('elements')
        end

        it 'assigns the name to the attributes' do
          menu = Menu.new
          menu.name('elements')
          menu.attributes[:name].must_equal('elements')
        end
      end
    end

  end
end
