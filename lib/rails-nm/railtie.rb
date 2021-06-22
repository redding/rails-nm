# frozen_string_literal: true

require "rails/railtie"
require "rails-nm"
require "rails-nm/template_handler"

module RailsNm; end

class RailsNm::Railtie < ::Rails::Railtie
  initializer(:rails_nm) do
    ::ActiveSupport.on_load(:action_view) do
      ::ActionView::Template.register_template_handler(
        RailsNm.config.extension,
        ::RailsNm::TemplateHandler,
      )
    end
  end
end
