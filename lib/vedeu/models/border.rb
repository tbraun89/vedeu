module Vedeu

  #
  #
  # @note Refer to UTF-8 U+2500 to U+257F for border characters. More details
  #   can be found at: http://en.wikipedia.org/wiki/Box-drawing_character
  #
  class Border

    # Returns a new instance of Border.
    #
    # @param interface [Interface]
    # @param attributes [Hash]
    # @return [Border]
    def initialize(interface, attributes = {})
      @interface  = interface
      @attributes = defaults.merge(attributes)
    end

    # Returns a boolean indicating whether the border is to be shown for this
    # interface.
    #
    # @return [Boolean]
    def enabled?
      attributes[:enabled]
    end

    # Returns a boolean indicating whether the bottom border is to be shown.
    #
    # @return [Boolean]
    def bottom?
      attributes[:show_bottom]
    end

    # Returns a boolean indicating whether the left border is to be shown.
    #
    # @return [Boolean]
    def left?
      attributes[:show_left]
    end

    # Returns a boolean indicating whether the right border is to be shown.
    #
    # @return [Boolean]
    def right?
      attributes[:show_right]
    end

    # Returns a boolean indicating whether the top border is to be shown.
    #
    # @return [Boolean]
    def top?
      attributes[:show_top]
    end

    # Returns a string representation of the border for the interface without
    # content.
    #
    # @return [Boolean]
    def to_s
      to_viewport.map { |line| line.flatten.join }.join("\n")
    end

    # Returns the interface with border (if enabled) and the content for the
    # interface.
    #
    # @return [Array<Array<String>>]
    def to_viewport
      return viewport unless enabled?

      out = []

      out << top if top?

      viewport[0...height].each do |line|
        out << [left, line[0...width], right].flatten
      end

      out << bottom if bottom?

      out
    end

    private

    attr_reader :attributes, :interface, :attributes

    # Renders the bottom border for the interface.
    #
    # @return [String]
    def bottom
      return [] unless bottom?

      out = []

      out << bottom_left if left?
      horizontal_border.each do |border|
        out << border
      end
      out << bottom_right if right?

      out
    end

    # Renders the left border for the interface.
    #
    # @return [String]
    def left
      return '' unless left?

      vertical_border
    end

    # Renders the right border for the interface.
    #
    # @return [String]
    def right
      return '' unless right?

      vertical_border
    end

    # Renders the top border for the interface.
    #
    # @return [String]
    def top
      return [] unless top?

      out = []
      out << top_left if left?
      horizontal_border.each do |border|
        out << border
      end
      out << top_right if right?

      out
    end

    # Renders the bottom left border character with escape codes for colour and
    # style for the interface.
    #
    # @return [String]
    def bottom_left
      [*presentation, on, bl, off, *reset].join
    end

    # Renders the bottom right border character with escape codes for colour and
    # style for the interface.
    #
    # @return [String]
    def bottom_right
      [*presentation, on, br, off, *reset].join
    end

    # Renders the top left border character with escape codes for colour and
    # style for the interface.
    #
    # @return [String]
    def top_left
      [*presentation, on, tl, off, *reset].join
    end

    # Renders the top right border character with escape codes for colour and
    # style for the interface.
    #
    # @return [String]
    def top_right
      [*presentation, on, tr, off, *reset].join
    end

    # Returns the width of the interface determined by whether a left, right,
    # both or neither borders are shown.
    #
    # @return [Fixnum]
    def width
      if left? && right?
        interface.width - 2

      elsif left? || right?
        interface.width - 1

      else
        interface.width

      end
    end

    # Returns the height of the interface determined by whether a top, bottom,
    # both or neither borders are shown.
    #
    # @return [Fixnum]
    def height
      if top? && bottom?
        interface.height - 2

      elsif top? || bottom?
        interface.height - 1

      else
        interface.height

      end
    end

    # Returns the horizontal border characters with colours and styles.
    #
    # @return [Array<String>]
    def horizontal_border
      [[*presentation, on, h, off, *reset].join] * width
    end

    def horizontal_space
      [' '] * width
    end

    # Returns the vertical border characters with colours and styles.
    #
    # @return [String]
    def vertical_border
      [*presentation, on, v, off, *reset].join
    end

    # Returns the horizontal border character.
    #
    # @return [String]
    def h
      attributes[:horizontal]
    end

    # Returns the vertical border character.
    #
    # @return [String]
    def v
      attributes[:vertical]
    end

    # Returns the top right border character.
    #
    # @return [String]
    def tr
      attributes[:top_right]
    end

    # Returns the top left border character.
    #
    # @return [String]
    def tl
      attributes[:top_left]
    end

    # Returns the bottom right border character.
    #
    # @return [String]
    def br
      attributes[:bottom_right]
    end

    # Returns the bottom left border character.
    #
    # @return [String]
    def bl
      attributes[:bottom_left]
    end

    # Returns the escape sequence to start a border.
    #
    # @return [String]
    def on
      "\e(0"
    end

    # Returns the escape sequence to end a border.
    #
    # @return [String]
    def off
      "\e(B"
    end

    # Returns the viewport for the interface.
    #
    # @return [String]
    def viewport
      interface.viewport
    end

    # Returns the colour and styles for the border.
    #
    # @return [String]
    def presentation
      [colour.to_s, style.to_s]
    end

    # Returns the colour and styles for the interface; effectively turning off
    # the colours and styles for the border.
    #
    # @return [String]
    def reset
      [interface.colour.to_s, interface.style.to_s]
    end

    # Returns a new Colour instance.
    #
    # @return [Colour]
    def colour
      @colour ||= Colour.new(attributes[:colour])
    end

    # Returns a new Style instance.
    #
    # @return [Style]
    def style
      @style ||= Style.new(attributes[:style])
    end

    # The default values for a new instance of Border.
    #
    # @return [Hash]
    def defaults
      {
        enabled:      false,
        show_bottom:  true,
        show_left:    true,
        show_right:   true,
        show_top:     true,
        bottom_right: "\x6A", # ┘
        top_right:    "\x6B", # ┐
        top_left:     "\x6C", # ┌
        bottom_left:  "\x6D", # └
        horizontal:   "\x71", # ─
        colour:       {},
        style:        [],
        vertical:     "\x78", # │
      }
    end

  end # Border

end # Vedeu