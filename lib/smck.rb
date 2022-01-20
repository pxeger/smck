# frozen_string_literal: true

require 'forwardable'
require 'nokogiri'
require 'psych'

require_relative './version'
require_relative './options'
require_relative './components'
require_relative './tagged_value'

module Smck
  class Error < StandardError; end

  # represents a Smck document
  class Document
    def initialize(options = Smck::Options.new)
      @doc = Nokogiri::HTML5::Document.parse <<~'END HTML'
        <!DOCTYPE html>
      END HTML
      @html = @doc.root
      @head, = @html > 'head'
      @body, = @html > 'body'
      @options = options
    end

    extend Forwardable
    def_delegators :@doc, :create_element, :create_text_node

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

    def self.render(data, options = Smck::Options.new)
      doc = new(options)
      doc.render data
      doc.to_html
    end
  end
end
