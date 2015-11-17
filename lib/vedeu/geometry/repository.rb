module Vedeu

  module Geometry

    # Allows the storing of interface/view geometry independent of the
    # interface instance.
    #
    class Repository < Vedeu::Repositories::Repository

      singleton_class.send(:alias_method, :geometries, :repository)

      null Vedeu::Geometry::Geometry, height: Vedeu.height, width: Vedeu.width
      real Vedeu::Geometry::Geometry

    end # Repository

  end # Geometry

  # Manipulate the repository of geometries.
  #
  # @example
  #   Vedeu.geometries
  #
  # @!method geometries
  # @return [Vedeu::Geometry::Repository]
  def_delegators Vedeu::Geometry::Repository,
                 :geometries

  # :nocov:

  # See {file:docs/events/view.md#\_maximise_}
  Vedeu.bind(:_maximise_) do |name|
    Vedeu.geometries.by_name(name).maximise
  end

  # See {file:docs/events/view.md#\_movement_refresh_}
  Vedeu.bind(:_movement_refresh_) do |name|
    Vedeu.trigger(:_clear_)
    Vedeu.trigger(:_refresh_)
    Vedeu.trigger(:_clear_view_, name)
    Vedeu.trigger(:_refresh_view_, name)
  end

  # See {file:docs/events/view.md#\_unmaximise_}
  Vedeu.bind(:_unmaximise_) do |name|
    Vedeu.geometries.by_name(name).unmaximise
  end

  [:down, :left, :right, :up].each do |direction|
    Vedeu.bind(:"_view_#{direction}_") do |name, offset|
      Vedeu::Geometry::Move.move(direction: direction,
                                 name:      name,
                                 offset:    offset)
    end
  end

  [:down, :left, :right, :up].each do |direction|
    Vedeu.bind_alias(:"_geometry_#{direction}_", :"_view_#{direction}_")
  end

  # :nocov:

end # Vedeu
