# frozen_string_literal: true

require "json"
require "much-config"
require "nm"
require "rails-nm/version"

module RailsNm
  include MuchConfig

  add_config

  def self.source
    @source ||= config.source
  end

  def self.encode(hash_or_array)
    config.encoder.call(hash_or_array)
  end

  def self.render_content(
        content,
        template_identifier:,
        context: Nm.default_context)
    encode(
      Nm::Context
        .new(context, source: source, locals: config.locals.to_h)
        .render_content(content, file_path: template_identifier),
    )
  end

  class Config
    attr_accessor :default_format, :extension, :locals, :encoder
    attr_writer :views_path, :cache

    def initialize
      @default_format = :json
      @extension = :nm
      @locals = {}

      @encoder = ->(hash_or_array){ ::JSON.dump(hash_or_array) }
    end

    def views_path
      @views_path ||= ::Rails.root.join("app/views")
    end

    def cache
      @cache = !::Rails.env.development? unless defined?(@cache)
      @cache
    end

    def source
      Nm::Source.new(
        views_path,
        cache: cache,
        extension: extension,
        locals: locals,
      )
    end
  end
end

require "rails-nm/railtie" if defined?(::Rails)
