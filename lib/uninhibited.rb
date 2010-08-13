require 'rspec'
require 'uninhibited/background_metadata'
require 'uninhibited/feature'
require 'uninhibited/formatter'
require 'uninhibited/version'

module Rspec::Core::ObjectExtensions
  def Feature(*args, &example_group_block)
    describe(*args) do
      extend Uninhibited::Feature
      instance_eval(&example_group_block) if block_given?
    end
  end
end

class RSpec::Core::Metadata
  include Uninhibited::BackgroundMetadata
end

if filter = RSpec.configuration.filter
  filter[:include_background] = true
end

RSpec.configuration.formatter = Uninhibited::Formatter
