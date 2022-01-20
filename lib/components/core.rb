# frozen_string_literal: true

module Smck::Components
  def ignore(data, parent) end

  def str(data, parent)
    parent.add_child create_text_node data
  end

  def raw_html(data, parent)
    raise Error, 'raw_html is not allowed' unless @options.allow_raw_html

    raise Error, "raw_html requires a string (found #{data.class})" unless data.is_a? String

    parent.add_child data
  end
end
