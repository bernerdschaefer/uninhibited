module Uninhibited
  module Feature
    def uninhibited?
      true
    end

    def skip_examples_after(example_group, example)
      examples = example_group.descendant_filtered_examples.flatten
      examples[examples.index(example)..-1].each do |e|
        e.metadata[:pending] = true
        e.metadata[:skipped] = true
      end
    end

    def Scenario(*args, &example_group_block)
      describe("Scenario:", *args, &example_group_block)
    end

    def Background(*args, &example_group_block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:background] = true
      describe("Background:", *args, options, &example_group_block)
    end

    %w(Given When Then And But).each do |type|
      module_eval(<<-END_RUBY, __FILE__, __LINE__)
        def #{type}(desc=nil, options={}, &block)
          example("#{type} \#{desc}", options, &block)
        end
      END_RUBY
    end

    def self.extended(base)
      base.after(:each) do
        if example.instance_variable_get(:@exception)
          if example.example_group.metadata[:background]
            self.class.skip_examples_after(self.class.ancestors[1], example)
          else
            self.class.skip_examples_after(self.class, example)
          end
        end
      end
    end
  end
end
