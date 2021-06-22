# frozen_string_literal: true

require "rails-nm"

module RailsNm; end

class RailsNm::TemplateHandler
  cattr_accessor :default_format
  self.default_format = RailsNm.config.default_format

  def self.call(template, source = nil)
    %{
      RailsNm.render_content(
        %{#{source || template.source}},
        context: self,
        template_identifier: "#{template.identifier}",
      )
    }
  end
end
