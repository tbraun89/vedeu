module Vedeu

  module Borders

    # Provides the mechanism to decorate an interface with a border on
    # all edges, or specific edges. The characters which are used for
    # the border parts (e.g. the corners, verticals and horizontals)
    # can be customised as can the colours and styles.
    #
    # More information can be found at: {file:docs/borders.md Borders}
    #
    # @note
    #   Refer to UTF-8 U+2500 to U+257F for border characters.
    #   More details can be found at:
    #   http://en.wikipedia.org/wiki/Box-drawing_character
    #
    class Border

      extend Forwardable
      include Vedeu::Common
      include Vedeu::Repositories::Model
      include Vedeu::Presentation

      def_delegators :geometry,
                     :bx,
                     :bxn,
                     :by,
                     :byn,
                     :x,
                     :xn,
                     :y,
                     :yn

      # @!attribute [rw] bottom_left
      # @return [String] The character to be used for the bottom left
      #   border if enabled.
      attr_accessor :bottom_left

      # @!attribute [rw] bottom_right
      # @return [String] The character to be used for the bottom right
      #   border if enabled.
      attr_accessor :bottom_right

      # @!attribute [rw] caption
      # @return [String] An optional caption for when the bottom
      #   border is to be shown.
      attr_accessor :caption

      # @!attribute [rw] horizontal
      # @return [String] The character to be used for the horizontal
      #   side border.
      attr_accessor :horizontal

      # @!attribute [rw] show_bottom
      # @return [Boolean] Determines whether the bottom border should
      #   be shown.
      attr_accessor :show_bottom
      alias_method :bottom?, :show_bottom

      # @!attribute [rw] show_left
      # @return [Boolean] Determines whether the left border should
      #   be shown.
      attr_accessor :show_left
      alias_method :left?, :show_left

      # @!attribute [rw] show_right
      # @return [Boolean] Determines whether the right border should
      #   be shown.
      attr_accessor :show_right
      alias_method :right?, :show_right

      # @!attribute [rw] show_top
      # @return [Boolean] Determines whether the top border should
      #   be shown.
      attr_accessor :show_top
      alias_method :top?, :show_top

      # @!attribute [rw] title
      # @return [String] An optional title for when the top border is
      #   to be shown.
      attr_accessor :title

      # @!attribute [rw] top_left
      # @return [String] The character to be used for the top left
      #   border if enabled.
      attr_accessor :top_left

      # @!attribute [rw] top_right
      # @return [String] The character to be used for the top right
      #   border if enabled.
      attr_accessor :top_right

      # @!attribute [rw] vertical
      # @return [String] The character to be used for the vertical
      #   side border.
      attr_accessor :vertical

      # @!attribute [r] name
      # @return [String|Symbol] Associates the border with the
      #   same-named interface/view.
      attr_reader :name

      # @!attribute [r] parent
      # @return [Vedeu::Interfaces::Interface|NilClass] The interface/
      #   view associated with this border.
      attr_reader :parent

      # @!attribute [r] enabled
      # @return [Boolean] Determines whether this border should be
      #   rendered.
      attr_accessor :enabled
      alias_method :enabled?, :enabled

      # Returns a new instance of Vedeu::Borders::Border.
      #
      # @param attributes [Hash<Symbol => Boolean|Hash|NilClass|
      #   String|Symbol|Vedeu::Borders::Repository|
      #   Vedeu::Presentation::Style>]
      # @option attributes bottom_left [String] The bottom left border
      #   character.
      # @option attributes bottom_right [String] The bottom right
      #   border character.
      # @option attributes colour [Hash]
      # @option attributes enabled [Boolean] Indicate whether the
      #   border is to be shown for this interface.
      # @option attributes horizontal [String] The horizontal border
      #   character.
      # @option attributes name [String|Symbol] The name of the
      #   interface to which this border relates.
      # @option attributes style [Vedeu::Presentation::Style]
      # @option attributes show_bottom [Boolean] Indicate whether the
      #   bottom border is to be shown.
      # @option attributes show_left [Boolean] Indicate whether the
      #   left border is to be shown.
      # @option attributes show_right [Boolean] Indicate whether the
      #   right border is to be shown.
      # @option attributes show_top [Boolean] Indicate whether the top
      #   border is to be shown.
      # @option attributes title [String] An optional title for when
      #   the top border is to be shown.
      # @option attributes caption [String] An optional caption for
      #   when the bottom border is to be shown.
      # @option attributes top_left [String] The top left border
      #   character.
      # @option attributes top_right [String] The top right border
      #   character.
      # @option attributes vertical [String] The vertical border
      #   character.
      # @return [Vedeu::Borders::Border]
      def initialize(attributes = {})
        defaults.merge!(attributes).each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      # @return [Hash<Symbol => Boolean|Hash|NilClass|String|Symbol|
      #   Vedeu::Borders::Repository|Vedeu::Presentation::Style>]
      def attributes
        {
          bottom_left:  @bottom_left,
          bottom_right: @bottom_right,
          caption:      @caption,
          client:       @client,
          colour:       @colour,
          enabled:      @enabled,
          horizontal:   @horizontal,
          name:         @name,
          parent:       @parent,
          repository:   @repository,
          show_bottom:  @show_bottom,
          show_left:    @show_left,
          show_right:   @show_right,
          show_top:     @show_top,
          style:        @style,
          title:        @title,
          top_left:     @top_left,
          top_right:    @top_right,
          vertical:     @vertical,
        }
      end

      # Returns a DSL instance responsible for defining the DSL
      # methods of this model.
      #
      # @param client [Object|NilClass] The client binding represents
      #   the client application object that is currently invoking a
      #   DSL method. It is required so that we can send messages to
      #   the client application object should we need to.
      # @return [Vedeu::Borders::DSL] The DSL instance for this model.
      def deputy(client = nil)
        Vedeu::Borders::DSL.new(self, client)
      end

      private

      # Returns the geometry for the interface.
      #
      # @return (see Vedeu::Geometry::Repository#by_name)
      def geometry
        Vedeu.geometries.by_name(name)
      end

      # The default values for a new instance of this class.
      #
      # @return [Hash<Symbol => Boolean|Hash|NilClass|String|Symbol|
      #   Vedeu::Borders::Repository|Vedeu::Presentation::Style>]
      # @see Vedeu::EscapeSequences::Borders
      def defaults
        {
          bottom_left:  Vedeu::EscapeSequences::Borders.bottom_left,
          bottom_right: Vedeu::EscapeSequences::Borders.bottom_right,
          caption:      '',
          client:       nil,
          colour:       nil,
          enabled:      false,
          horizontal:   Vedeu::EscapeSequences::Borders.horizontal,
          name:         '',
          parent:       nil,
          repository:   Vedeu.borders,
          show_bottom:  true,
          show_left:    true,
          show_right:   true,
          show_top:     true,
          style:        nil,
          title:        '',
          top_left:     Vedeu::EscapeSequences::Borders.top_left,
          top_right:    Vedeu::EscapeSequences::Borders.top_right,
          vertical:     Vedeu::EscapeSequences::Borders.vertical,
        }
      end

    end # Border

  end # Borders

end # Vedeu
