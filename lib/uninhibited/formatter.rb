module Uninhibited
  class Formatter < RSpec::Core::Formatters::DocumentationFormatter
    attr_accessor :skipped_examples, :skipped_count

    def initialize(*)
      super
      @skipped_examples = []
      @skipped_count = 0
    end

    def uninhibited?
      example_group.respond_to?(:uninhibited?) && example_group.uninhibited?
    end

    def example_pending(example)
      if uninhibited? && example.metadata[:skipped]
        @skipped_examples << pending_examples.delete(example)
        @skipped_count += 1
        output.puts cyan("#{current_indentation}#{example.description}")
      else
        pending_examples << example
        super
      end
    end

    def colorise_summary(summary)
      summary
    end

    def summary_line(example_count, failure_count, pending_count)
      summary = pluralize(example_count, "example")
      summary << " ("
      summary << red(pluralize(failure_count, "failure"))
      summary << ", " << yellow("#{pending_count} pending") if pending_count > 0
      summary << ", " << cyan("#{skipped_count} skipped") if skipped_count > 0
      summary << ")"
      summary
    end

    def cyan(text)
      color(text, "\e[36m")
    end
  end
end
