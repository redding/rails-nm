# frozen_string_literal: true

require "action_view/testing/resolvers"

module TestActionView
  def self.render(source, **ivars)
    JSON.parse(new(source, **ivars).render(template: "source"))
  end

  def self.new(source, **ivars)
    resolver = ActionView::FixtureResolver.new({ "source.json.nm" => source })
    lookup_context = ActionView::LookupContext.new([resolver], {}, [""])
    controller = ActionView::TestCase::TestController.new

    view =
      ActionView::Base.with_empty_template_cache.new(
        lookup_context,
        ivars.to_h,
        controller,
      )
    def view.view_cache_dependencies
      []
    end

    view
  end
end
