require 'json'
require 'virtus'

require_relative 'presentation'
require_relative '../support/terminal'
require_relative 'style'

module Vedeu
  class Stream
    include Virtus.model
    include Presentation
    include Style

    attribute :text, String, default: ''

    def to_json
      json_attributes.to_json
    end

    def to_s(options = {})
      [colour, style, text].join
    end

    private

    def json_attributes
      {
        colour: colour,
        style:  style_original,
        text:   text
      }
    end
  end
end
