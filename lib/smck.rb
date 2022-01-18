# frozen_string_literal: true

require 'nokogiri'
require 'psych'

require_relative './version'
require_relative './base_markup'
require_relative './tagged_value'

module Smck
  class Error < StandardError; end

  # Components module contains methods for rendering different tags of markup
  # They are defined as instance methods rather than class methods to allow avoiding send, which is insecure
  module Components
    # core markup definitions

    def ignore(data, parent) end

    def str(data, parent)
      parent.add_child create_text_node data
    end
  end

  # sanity check
  %i[eval send].each do |name|
    raise SecurityError, "Components must not allow #{name}" if Smck::Components.instance_methods.include? name
  end

  # represents a Smck document
  class Document
    def initialize
      @doc = Nokogiri::HTML5::Document.parse <<~'END HTML'
        <!DOCTYPE html>
      END HTML
      @html = @doc.root
      @head, = @html > 'head'
      @body, = @html > 'body'
    end

    def create_element(...)
      @doc.create_element(...)
    end

    def create_text_node(...)
      @doc.create_text_node(...)
    end

    # render YAML +data+ to the document's +body+
    def render(data)
      render_item data, @body
    end

    # render YAML +data+ as new children of +parent+
    def render_item(data, parent)
      case data
      in String
        render_component :str, data, parent
      in Array
        data.each do |child|
          render_item(child, parent)
        end
      in Smck::TaggedValue[tag:, value:]
        component = tag.delete_prefix('!').to_sym
        render_component component, value, parent
      else
        raise Error, "unsupported value type #{data.class}"
      end
    end

    def render_component(name, value, parent)
      raise Error, "unknown component #{name}" unless Components.instance_methods.include? name

      Components.instance_method(name).bind(self).call(value, parent)
    end

    def to_html
      @doc.to_html
    end

    def self.render(data)
      doc = new
      doc.render data
      doc.to_html
    end
  end
end
