require 'rspec'
require 'uninhibited/background_metadata'
require 'uninhibited/feature'
require 'uninhibited/formatter'
require 'uninhibited/version'

module Rspec::Core::ObjectExtensions
  def Feature(*args, &example_group_block)
    example_group = describe(*args, &example_group_block)
    example_group.extend(Uninhibited::Feature)
    example_group
  end
end

class RSpec::Core::ExampleGroup
  def self.Scenario(*args, &example_group_block)
    describe("Scenario:", *args, &example_group_block)
  end

  def self.Background(*args, &example_group_block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options[:background] = true
    describe("Background:", *args, options, &example_group_block)
  end

  %w(Given When Then And But).each do |type|
    module_eval(<<-END_RUBY, __FILE__, __LINE__)
      def self.#{type}(desc=nil, options={}, &block)
        example("#{type} \#{desc}", options, &block)
      end
    END_RUBY
  end

end

class RSpec::Core::Metadata
  include Uninhibited::BackgroundMetadata
end

if filter = RSpec.configuration.filter
  filter[:include_background] = true
end

RSpec.configuration.formatter = Uninhibited::Formatter
