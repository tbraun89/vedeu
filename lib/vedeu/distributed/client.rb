require 'drb'

module Vedeu

  module Distributed

    # A class for the client side of the DRb server/client relationship.
    #
    # @example
    #   client = Vedeu::Distributed::Client.connect("druby://localhost:21420")
    #   client.input('a')
    #   client.output # => 'some content...'
    #
    class Client

      # @param uri [String]
      # @return [Client]
      def self.connect(uri)
        new(uri).connect
      end

      # @param uri [String]
      # @return [Client]
      def initialize(uri)
        @uri = uri.to_s
      end

      # Simulate connecting to the DRb server by requesting its status.
      #
      # @return [Symbol]
      def connect
        server.status

      rescue DRb::DRbBadURI
        puts "Could not connect to DRb server, URI may be bad."

      rescue DRb::DRbConnError
        puts "Could not connect to DRb server."

      end

      # Send input to the DRb server.
      #
      # @param data [String|Symbol]
      # @return [void]
      def input(data)
        server.input(data)

      rescue DRb::DRbConnError
        puts "Could not connect to DRb server."

      end
      alias_method :read, :input

      # Fetch output from the DRb server.
      #
      # @return [void]
      def output
        server.output

      rescue DRb::DRbConnError
        puts "Could not connect to DRb server."

      end
      alias_method :write, :output

      # Shutdown the DRb server and the client application.
      #
      # @note
      #   {Vedeu::Application} will raise StopIteration when its `.stop` method
      #   is called. Here we rescue that to give a clean client exit.
      #
      # @return [void]
      def shutdown
        server.shutdown

        Process.kill("KILL", server.pid)

      rescue DRb::DRbConnError
        puts "Could not connect to DRb server."

      rescue Interrupt
        puts "Client application exited."

      end

      private

      attr_reader :uri

      # @return [void]
      def server
        @server ||= DRbObject.new_with_uri(uri)
      end

    end # Client

  end # Distributed

end # Vedeu