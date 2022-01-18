# frozen_string_literal: true

module Smck::Components
  # simple tag components
  {
    bold: 'strong',
    italic: 'em'
  }.each_pair do |name, element|
    define_method name do |data, parent|
      el = create_element element
      parent.add_child el
      render_item data, el
    end
  end
end

# sanity check
%i[eval send].each do |name|
  raise SecurityError, "Components must not allow #{name}" if Smck::Components.instance_methods.include? name
end
