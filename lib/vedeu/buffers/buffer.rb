module Vedeu

  # The Buffer object represents the states of display for an interface. The
  # states are 'front', 'back' and 'previous'.
  #
  # [Back] -> [Front] -> [Previous]
  #
  # The content on the screen, or last output will always be the 'Front' buffer.
  # Content due to be displayed on next refresh will come from the 'Back' buffer
  # if available, otherwise from the current 'Front' buffer. When new content
  # is copied to the 'Front' buffer, the current 'Front' buffer is also copied
  # to the 'Previous' buffer.
  #
  # @api private
  class Buffer

    include Vedeu::Model

    # The next buffer to be displayed; contains the content which will be shown
    # on next refresh.
    #
    # @!attribute [rw] back
    # @return [Interface]
    attr_accessor :back

    # The currently displayed buffer, contains the content which was last
    # output.
    #
    # @!attribute [rw] front
    # @return [Interface]
    attr_accessor :front

    # The previous buffer which was displayed; contains the content that was
    # shown before 'front'.
    #
    # @!attribute [rw] previous
    # @return [Interface]
    attr_accessor :previous

    # @!attribute [r] name
    # @return [String]
    attr_reader :name

    # Return a new instance of Buffer. Generally a Buffer is initialized with
    # only a 'name' and 'back' parameter.
    #
    # @option attributes name [String] The name of the interface for which the
    #   buffer belongs.
    # @option attributes back [Vedeu::Interface]
    # @option attributes front [Vedeu::Interface]
    # @option attributes previous [Vedeu::Interface]
    # @option attributes repository [Vedeu::Buffers]
    # @return [Vedeu::Buffer]
    def initialize(attributes = {})
      @attributes = defaults.merge!(attributes)

      @attributes.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    # Add the content to the back buffer, then update the repository.
    # Returns boolean indicating that the repository was updated.
    #
    # @param content [Vedeu::Interface]
    # @return [Boolean]
    def add(content)
      @back = content

      store

      true
    end

    # Return a boolean indicating content presence on the buffer type.
    #
    # @return [Boolean] Whether the buffer targetted has content.
    def back?
      return false if back.nil? || back.content.empty?

      true
    end

    # Returns the front buffer or, if that is empty, the interface cleared.
    #
    # @return [void]
    def clear
      Vedeu::Output.render(clear_buffer)
    end

    # Return a boolean indicating content presence on the buffer type.
    #
    # @return [Boolean] Whether the buffer targetted has content.
    def front?
      return false if front.nil? || front.content.empty?

      true
    end

    # Return a boolean indicating content presence on the buffer type.
    #
    # @return [Boolean] Whether the buffer targetted has content.
    def previous?
      return false if previous.nil? || previous.content.empty?

      true
    end

    # Hide this buffer.
    #
    # @return [void]
    def hide
      return nil unless visible?

      Vedeu::Visibility.hide(interface)
      clear
    end

    # Return the content for this buffer.
    #
    # - If we have new content (i.e. content on 'back') to be shown, we first
    #   clear the area occupied by the previous content, then clear the area for
    #   the new content, and then finally render the new content.
    # - If there is no new content (i.e. 'back' is empty), check the 'front'
    #   buffer and display that.
    # - If there is no new content, and the front buffer is empty, display the
    #   'previous' buffer.
    # - If the 'previous' buffer is empty, return an empty collection.
    #
    # @return [Array<Array<Array<Vedeu::Char>>>]
    def render
      Vedeu::Output.render(buffer)
    end
    alias_method :content, :render

    # Show this buffer.
    #
    # @return [void]
    def show
      return nil if visible?

      Vedeu::Visibility.show(interface)
      render
    end

    private

    # Retrieve the latest content from the buffer.
    #
    # @return [Array<Array<Array<Vedeu::Char>>>]
    def buffer
      swap if back?

      if front?
        [front.render]

      elsif previous?
        [previous.render]

      else
        []

      end
    end

    # Clear the buffer.
    #
    # @return [void]
    def clear_buffer
      @clear_buffer ||= Vedeu::Clear.new(view).clear
    end

    # @return [Hash<Symbol => NilClass, String>]
    def defaults
      {
        back:       nil,
        front:      nil,
        name:       '',
        previous:   nil,
        repository: Vedeu.buffers,
      }
    end

    # Return a boolean indicating content was swapped between buffers.
    #
    # @return [Boolean]
    def swap
      Vedeu.log(type: :output, message: "Buffer swapping: '#{name}'")

      @previous = front
      @front    = back
      @back     = nil

      store

      true
    end

    # Retrieve the interface by name.
    #
    # @return [Vedeu::Interface]
    def interface
      @interface ||= Vedeu.interfaces.by_name(name)
    end

    # @return [Vedeu::Interface]
    def view
      if front?
        front

      else
        interface

      end
    end

    # @see Vedeu::Interface#visible
    def visible?
      interface.visible?
    end

  end # Buffer

end # Vedeu
