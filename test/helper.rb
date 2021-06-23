# frozen_string_literal: true

# This file is automatically required when you run `assert`; put any test
# helpers here.

# Add the root dir to the load path.
ROOT = Pathname.new(File.expand_path("../..", __FILE__))
$LOAD_PATH.unshift(ROOT.to_s)

TEST_SUPPORT_ROOT = ROOT.join("test/support")

# Require pry for debugging (`binding.pry`).
require "pry"

require "test/support/factory"

require "active_support"
require "action_view"
require "rails/version"

def Rails.root
  TEST_SUPPORT_ROOT
end

def Rails.env
  @env ||= FakeEnv.new
end

class FakeEnv
  def development?
    true
  end
end

require "rails-nm"
require "rails-nm/template_handler"
ActionView::Template.register_template_handler(:nm, RailsNm::TemplateHandler)

require "test/support/test_action_view"

class Assert::Context
  private

  def render(source, **locals)
    TestActionView.render(source, **locals)
  end
end
