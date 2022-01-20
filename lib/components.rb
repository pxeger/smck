# frozen_string_literal: true

require_relative 'components/inline_markup'
require_relative 'components/core'

module Smck
  # Components module contains methods for rendering different tags of markup
  # They are defined as instance methods rather than class methods to allow avoiding send, which is insecure
  module Components end

  # sanity check
  %i[eval send].each do |name|
    raise SecurityError, "Components must not allow #{name}" if Smck::Components.instance_methods.include? name
  end
end
