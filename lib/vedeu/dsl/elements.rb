module Vedeu

  module DSL

    # Provides methods to be used to define views.
    #
    #   Vedeu.renders do
    #     view :my_interface do
    #       lines do
    #         background '#000000'
    #         foreground '#ffffff'
    #         line 'This is white text on a black background.'
    #         line 'Next is a blank line:'
    #         line ''
    #
    #         streams { stream 'We can define ' }
    #
    #         streams do
    #           foreground '#ff0000'
    #           stream 'parts of a line '
    #         end
    #
    #         streams { stream 'independently using ' }
    #
    #         streams do
    #           foreground '#00ff00'
    #           stream 'streams.'
    #         end
    #       end
    #     end
    #   end
    #
    # @api public
    #
    module Elements

      include Vedeu::Common

      # @param block [Proc]
      # @raise [Vedeu::Error::RequiresBlock|Vedeu::Error::Fatal]
      # @return [void]
      def lines(&block)
        requires_block!(&block)
        requires_model!

        attrs = Vedeu::DSL::Attributes.build(self, model, nil, {}, &block)

        l = Vedeu::Views::View.build(attrs, &block)
        model.value = l.value
      end

      # Specify a single line in a view.
      #
      #   Vedeu.renders do
      #     view :my_interface do
      #       lines do
      #         line 'some text...'
      #         # ... some code
      #
      #         line 'some more text...'
      #         # ... some code
      #       end
      #     end
      #   end
      #
      # @param value [String] The value for the line. Ignored when a
      #   block is given.
      # @param opts [Hash]
      # @option opts ... [void]
      # @param block [Proc]
      # @raise [Vedeu::Error::Fatal]
      # @return [void]
      def line(value = '', opts = {}, &block)
        requires_model!

        attrs = Vedeu::DSL::Attributes.build(self, model, value, opts, &block)

        l = if block_given?
              Vedeu::Views::Line.build(attrs, &block)

            else
              s  = Vedeu::Views::Stream.new(attrs)
              ss = Vedeu::Views::Streams.coerce([s])

              Vedeu::Views::Line.new(attrs.merge!(value: ss))

            end

        if view_model? || line_model?
          model.add(l)

        else
          fail Vedeu::Error::Fatal,
               "Cannot add line to '#{model.class.name}' model."

        end
      end

      # Define multiple streams (a stream is a subset of a line).
      # Uses {Vedeu::DSL::Stream} for all directives within the
      # required block.
      #
      #   Vedeu.renders do
      #     view :my_interface do
      #       lines do
      #         line do
      #           streams do
      #             # ... some code
      #           end
      #
      #           stream do
      #             # ... some code
      #           end
      #         end
      #       end
      #     end
      #   end
      #
      # @param block [Proc]
      # @raise [Vedeu::Error::RequiresBlock|Vedeu::Error::Fatal]
      # @return [void]
      def streams(&block)
        requires_block!(&block)
        requires_model!

        attrs = Vedeu::DSL::Attributes.build(self, model, nil, {}, &block)

        l = Vedeu::Views::Line.build(attrs, &block)

        if view_model?
          model.add(l)

        elsif line_model?
          model.value = l.value

        end
      end

      # @param value [String]
      # @param opts [Hash]
      # @option opts ... [void]
      # @param block [Proc]
      # @raise [Vedeu::Error::Fatal]
      # @return [void]
      def stream(value = '', opts = {}, &block)
        requires_model!

        attrs = Vedeu::DSL::Attributes.build(self, model, value, opts, &block)

        l = if block_given?
              Vedeu::Views::Line.build(attrs, &block)

            else
              s  = Vedeu::Views::Stream.new(attrs)
              ss = Vedeu::Views::Streams.coerce([s])

              Vedeu::Views::Line.new(attrs.merge!(value: ss))

            end

        if view_model? || line_model?
          model.add(l)

        else
          fail Vedeu::Error::Fatal,
               "Cannot add line to '#{model.class.name}' model."

        end
      end

      # @param value [String]
      # @param opts [Hash]
      # @option opts ... [void]
      # @raise [Vedeu::Error::Fatal]
      # @return [void]
      def text(value = '', opts = {})
        requires_model!

        options = text_align(__callee__, opts)

        if view_model? || line_model?
          attrs = Vedeu::DSL::Attributes.build(self, model, value, options)
          s  = Vedeu::Views::Stream.new(attrs)
          ss = Vedeu::Views::Streams.coerce([s])
          l  = Vedeu::Views::Line.new(attrs.merge!(value: ss))

          model.add(l)

        else
          fail Vedeu::Error::Fatal,
               "Cannot add text to '#{model.class.name}' model."

        end
      end
      alias_method :center, :text
      alias_method :centre, :text
      alias_method :left,   :text
      alias_method :right,  :text

      private

      # @return [Boolean]
      def line_model?
        model.is_a?(Vedeu::Views::Line)
      end

      # @param block [Proc]
      # @raise [Vedeu::Error::RequiresBlock] When the required block
      #   is not given.
      # @return [NilClass]
      def requires_block!(&block)
        fail Vedeu::Error::RequiresBlock unless block_given?
      end

      # @raise [Vedeu::Error::Fatal] When the model cannot be
      #   determined.
      # @return [NilClass]
      def requires_model!
        fail Vedeu::Error::Fatal,
             'No model, cannot continue.' unless present?(model)
      end

      # @return [Boolean]
      def stream_model?
        model.is_a?(Vedeu::Views::Stream)
      end

      # @param callee [Symbol]
      # @param opts [Hash]
      # @return [Hash]
      def text_align(callee, opts)
        return opts if valid_alignment?(opts)

        opts.merge!(align: callee)
      end

      # @return [Boolean]
      def valid_alignment?(opts)
        [:center, :centre, :left, :right].include?(opts[:align])
      end

      # @return [Boolean]
      def view_model?
        model.is_a?(Vedeu::Views::View)
      end

    end # Elements

  end # DSL

end # Vedeu
