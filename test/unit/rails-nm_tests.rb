# frozen_string_literal: true

require "assert"
require "rails-nm"

require "much-config"
require "nm/source"

module RailsNm
  class UnitTests < Assert::Context
    desc "RailsNm"
    subject{ unit_module }

    let(:unit_module){ RailsNm }

    should have_imeths :source, :encode, :render_content

    should "be configured as expected" do
      assert_that(subject).includes(MuchConfig)
      assert_that(subject.config).is_a(unit_module::Config)
    end

    should "know its attributes" do
      assert_that(subject.source).equals(subject.config.source)
    end

    should "encode using the configured encoder" do
      object = [{ key: "value" }, ["key", "value"]].sample
      assert_that(subject.encode(object)).equals(JSON.dump(object))
    end

    # See test/system/rails-nm_tests.rb for system tests that test rendering
    # template content.
  end

  class ConfigTests < UnitTests
    desc "Config"
    subject{ config_class }

    let(:config_class){ unit_module::Config }
  end

  class ConfigInitTests < ConfigTests
    desc "when init"
    subject{ config_class.new }

    should have_accessors :views_path, :default_format, :extension
    should have_accessors :locals, :cache, :encoder
    should have_imeths :source

    should "know its attributes" do
      assert_that(subject.views_path).equals(::Rails.root.join("app/views"))
      assert_that(subject.default_format).equals(:json)
      assert_that(subject.extension).equals(:nm)
      assert_that(subject.locals).equals({})
      assert_that(subject.cache).equals(!Rails.env.development?)
      assert_that(subject.encoder).is_a(Proc)
      assert_that(subject.source)
        .equals(
          Nm::Source.new(
            subject.views_path,
            cache: subject.cache,
            extension: subject.extension,
            locals: subject.locals,
          ),
        )
    end
  end
end
