# frozen_string_literal: true

module Smck
  class Options
    def initialize
      @allow_raw_html = false
    end

    attr_accessor :allow_raw_html
  end
end
