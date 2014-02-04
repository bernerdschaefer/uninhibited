require 'rspec/core/formatters/documentation_formatter'

module Uninhibited

  # Custom formatter for displaying the results of a feature.
  class Formatter < RSpec::Core::Formatters::DocumentationFormatter

    # the number of skipped examples
    # @attr [Integer]
    attr_accessor :skipped_count

    # the skipped examples
    # @attr_reader [Array]
    attr_reader :skipped_examples

    # Builds a new formatter for outputting Uninhibited features.
    #
    # @api rspec
    # @param [IO] output the output stream
    def initialize(output)
      super
      @skipped_examples = []
      @skipped_count = 0
    end

    # Adds the pending example to skipped examples array if it was skipped,
    # otherwise it delegates to super.
    #
    # @api rspec
    def example_pending(example)
      if example_group.metadata[:feature] && example.metadata[:skipped]
        @skipped_examples << pending_examples.delete(example)
        @skipped_count += 1
        output.puts cyan("#{current_indentation}#{example.description}")
      else
        super
      end
    end

    # Stubbed method to return the summary as provided, since the summary will
    # already be colorized.
    #
    # @return [String] the output summary
    #
    # @api rspec
    def colorise_summary(summary)
      summary
    end

    # Generates a colorized summary line based on the supplied arguments.
    #
    #   formatter.summary_line(1, 0, 0)
    #   # => 1 example (0 failures)
    #
    #   formatter.summary_line(2, 1, 1)
    #   # => 2 examples (1 failure, 1 pending)
    #
    #   formatter.skipped_count += 1
    #   formatter.summary_line(2, 0, 0)
    #   # => 2 examples (1 failure, 1 skipped)
    #
    # @param [Integer] example_count the total examples run
    # @param [Integer] failure_count the failed examples
    # @param [Integer] pending_count the pending examples
    #
    # @return [String] the formatted summary line
    #
    # @api rspec
    def summary_line(example_count, failure_count, pending_count)
      pending_count -= skipped_count
      summary = pluralize(example_count, "example")
      summary << " ("
      summary << red(pluralize(failure_count, "failure"))
      summary << ", " << yellow("#{pending_count} pending") if pending_count > 0
      summary << ", " << cyan("#{skipped_count} skipped") if skipped_count > 0
      summary << ")"
      summary
    end

    # Generate a string to output to the terminal with cyan coloration
    #
    # @param  [String] text the text to be colorized
    # @return [String] colorized text
    def cyan(text)
      color(text, "\e[36m")
    end

  end

end
