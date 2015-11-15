module Vedeu

  module Geometry

    # Provides a non-existent model to swallow messages.
    #
    # @api private
    #
    class Null < Vedeu::Null::Generic

      extend Forwardable

      def_delegators :area,
                     :bordered_height,
                     :bordered_width,
                     :bottom,
                     :bx,
                     :bxn,
                     :by,
                     :byn,
                     :east,
                     :height,
                     :left,
                     :north,
                     :right,
                     :south,
                     :top,
                     :west,
                     :width,
                     :x,
                     :xn,
                     :y,
                     :yn

      # @!attribute [rw] maximised
      # @return [Boolean]
      attr_accessor :maximised

      # @!attribute [r] name
      # @return [NilClass|String|Symbol]
      attr_reader :name

      # Returns a new instance of Vedeu::Geometry::Null.
      #
      # @param attributes [Hash<Symbol => void>]
      # @option attributes name [String|Symbol|NilClass]
      # @return [Vedeu::Geometry::Null]
      def initialize(attributes = {})
        @attributes = attributes
        @name       = @attributes[:name]
        @maximised  = @attributes.fetch(:maximised, false)
      end

      private

      # @return [Vedeu::Geometry::Area]
      def area
        @area ||= Vedeu::Geometry::Area.from_attributes(y_default: Vedeu.height,
                                                        x_default: Vedeu.width)
      end

    end # Null

  end # Geometry

end # Vedeu
