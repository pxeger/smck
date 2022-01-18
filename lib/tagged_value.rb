# frozen_string_literal: true

require 'psych'

module Smck
  # TaggedValue represents a YAML value with a tag, e.g. !tag 'value'
  class TaggedValue
    def initialize(tag, value)
      @tag = tag
      @value = value
    end

    def deconstruct_keys(_)
      { tag: @tag, value: @value }
    end
  end

  # cut out original Psych::Visitors::ToRuby#accept to provide TaggedValue
  # TODO(pxeger): is it possible to put this in a refinement? (probably not)
  class Psych::Visitors::ToRuby
    def accept(target)
      result = super
      result = TaggedValue.new target.tag, result if target.tag
      result
    end
  end
end
