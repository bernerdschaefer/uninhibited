module Uninhibited
  module Feature
    extend self
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

    def self.extended(base)
      base.after(:each) do
        if example.instance_variable_get(:@exception)
          if example.example_group.metadata[:background]
            Uninhibited::Feature.skip_examples_after(self.class.ancestors[1], example)
          else
            Uninhibited::Feature.skip_examples_after(self.class, example)
          end
        end
      end
    end
  end
end
