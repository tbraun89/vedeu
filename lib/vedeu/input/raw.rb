# frozen_string_literal: true

module Vedeu

  module Input

    # Handle input when terminal is in :raw (character at a time)
    # mode.
    #
    # @api private
    #
    class Raw

      # @see Vedeu::Input::Raw#initialize
      def self.read
        new.read
      end

      # Returns a new instance of Vedeu::Input::Raw.
      #
      # @return [Vedeu::Input::Raw]
      def initialize; end

      # @return [String]
      def read
        keys = console.getch

        if keys.ord == Vedeu::ESCAPE_KEY_CODE
          keys << console.read_nonblock(4) rescue nil
          keys << console.read_nonblock(3) rescue nil
          keys << console.read_nonblock(2) rescue nil
        end

        keys
      end

      private

      # @return [IO]
      def console
        @_console ||= Vedeu::Terminal.console
      end

    end # Raw

  end # Input

end # Vedeu
