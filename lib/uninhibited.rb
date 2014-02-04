require 'rspec'
require 'uninhibited/background_metadata'
require 'uninhibited/feature'
require 'uninhibited/formatter'
require 'uninhibited/object_extensions'
require 'uninhibited/version'

module Uninhibited

  # Set up Uninhibited's required features, and configures RSpec as necessary.
  def self.setup
    Object.send(:include, Uninhibited::ObjectExtensions)

    RSpec::Core::Metadata.send(:include, BackgroundMetadata)

    config = RSpec.configuration
    config.filter[:include_background] = true if config.filter

    if config.formatter_class == RSpec::Core::Formatters::DocumentationFormatter
      config.formatter = Uninhibited::Formatter
    end

    config.extend Uninhibited::Feature, :feature => true

    config.after(:each, :feature => true) do
      example.example_group.handle_exception(example)
    end
  end

end

Uninhibited.setup
