require 'ostruct'
require 'redcarpet'

module Kss
  module ApplicationHelper
    # Generates a styleguide block. A little bit evil with @_out_buf, but
    # if you're using something like Rails, you can write a much cleaner helper
    # very easily.
    def styleguide_block(section, &block)
      raise ArgumentError, "Missing block" unless block_given?
      
      @section = styleguide.section(section)

      if !@section.raw
        raise "KSS styleguide section is nil, is section '#{section}' defined in your css?"
      end

      content = capture(&block)
      render 'kss/shared/styleguide_block', :section => @section, :example_html => content
    end

    def styleguide_entry(section)
      @section = styleguide.section(section)
      @section = OpenStruct.new({section: section}) unless @section.raw
      render 'kss/shared/styleguide_entry', :section => @section
    end

    def markdown(section)
      md.render section
    end

    private

    def md
      @@md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :no_intra_emphasis => true)
    end
  end
end
