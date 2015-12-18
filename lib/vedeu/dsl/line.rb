module Vedeu

  module DSL

    # Provides methods to be used to define views.
    #
    class Line

      include Vedeu::DSL
      include Vedeu::DSL::Presentation
      include Vedeu::DSL::Elements

    end # Line

  end # DSL

end # Vedeu
