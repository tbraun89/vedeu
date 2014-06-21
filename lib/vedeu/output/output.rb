module Vedeu
  class Output
    class << self
      def render
        new.render
      end
    end

    def initialize; end

    def render
      InterfaceRepository.refresh.each do |interface|
        interface.each { |stream| Terminal.output(stream) if stream }
      end
    end
  end
end