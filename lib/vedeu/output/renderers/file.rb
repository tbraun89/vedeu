module Vedeu

  module Renderers

    # Writes the given output to a file.
    #
    class File

      include Vedeu::Renderers::RendererOptions

      # Returns a new instance of Vedeu::Renderers::File.
      #
      # @param options [Hash]
      # @option options filename [String] Provide a filename for the
      #   output. Defaults to 'out'.
      # @option options timestamp [Boolean] Append a timestamp to the
      #   filename.
      # @option options write_file [Boolean] Whether to write the file
      #   to the given filename.
      # @return [Vedeu::Renderers::File]
      def initialize(options = {})
        @options = options || {}
      end

      # Render a cleared output.
      #
      # @return [String]
      def clear
        ::File.write(filename, '') if write_file?

        ''
      end

      # @param output [Vedeu::Models::Page]
      # @return [String]
      def render(output)
        ::File.write(filename, output) if write_file?

        output
      end

      private

      # @return [String]
      def filename
        options[:filename] + "_#{timestamp}"
      end

      # @return [Float]
      def timestamp
        Time.now.to_f if options[:timestamp]
      end

      # @return [Boolean]
      def write_file?
        options[:write_file]
      end

      # Returns the default options/attributes for this class.
      #
      # @return [Hash]
      def defaults
        {
          filename:   'out',
          timestamp:  false,
          write_file: true,
        }
      end

    end # File

  end # Renderers

end # Vedeu
