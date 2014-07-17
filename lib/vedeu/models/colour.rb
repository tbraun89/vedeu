require 'oj'
require 'virtus'

require_relative '../support/esc'

module Vedeu
  class Colour
    include Virtus.model

    attribute :foreground, String
    attribute :background, String

    def foreground
      @fg ||= Esc.foreground_colour(css_foreground)
    end

    def background
      @bg ||= Esc.background_colour(css_background)
    end

    def css_foreground
      @foreground || ''
    end

    def css_background
      @background || ''
    end

    def to_json
      Oj.dump(as_hash, mode: :compat)
    end

    def to_s
      foreground + background
    end

    def as_hash
      {
        foreground: css_foreground,
        background: css_background,
      }
    end
  end
end
