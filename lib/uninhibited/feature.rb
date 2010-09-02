module Uninhibited

  # Features
  # @todo complete
  module Feature

    # Defines a new Scenario group
    #
    #   Feature "User signs in" do
    #     Scenario "success" do
    #       Given "I on the login page"
    #       When "I fill in my email and password"
    #     end
    #   end
    #
    # This will be printed like so:
    #
    #   Feature: User signs in
    #     Scenario: success
    #       Given I am on the login page
    #       When I fill in my email and password
    #
    # @param args the description, metadata, etc. as RSpec's #describe method
    # takes.
    # @param example_group_block the block to be executed within the feature
    def Scenario(*args, &example_group_block)
      describe("Scenario:", *args) do
        instance_eval(&example_group_block) if block_given?
      end
    end

    # Defines a new Background group
    #
    #   Feature "Something" do
    #     Background do
    #       Given "I..."
    #     end
    #     Scenario "success" do
    #       When "I..."
    #     end
    #     Scenario "failure" do
    #       When "I..."
    #     end
    #   end
    #
    # This will be printed like so:
    #
    #   Feature: User signs in
    #     Background:
    #       Given I...
    #     Scenario: success
    #       When I...
    #     Scenario: failure
    #       When I...
    #
    # @param args the description, metadata, etc. as RSpec's #describe method
    # takes.
    # @param example_group_block the block to be executed within the feature
    def Background(*args, &example_group_block)
      describe("Background:", *args) do
        metadata[:background] = true

        instance_eval(&example_group_block) if block_given?
      end
    end

    # Defines a new Given example
    #
    #   Given "I am on the home page" do
    #     visit root_path
    #   end
    #
    # @param [String] desc the description
    # @param [Hash] options the metadata for this example
    # @param block the example's code
    def Given(desc=nil, options={}, &block)
      example("Given #{desc}", options, &block)
    end

    # Defines a new When example
    #
    #   When "I click Home" do
    #     click_link "Home"
    #   end
    #
    # @param [String] desc the description
    # @param [Hash] options the metadata for this example
    # @param block the example's code
    def When(desc=nil, options={}, &block)
      example("When #{desc}", options, &block)
    end

    # Defines a new Then example
    #
    #   Then "I see a welcome message" do
    #     page.should have_content("Welcome!")
    #   end
    #
    # @param [String] desc the description
    # @param [Hash] options the metadata for this example
    # @param block the example's code
    def Then(desc=nil, options={}, &block)
      example("Then #{desc}", options, &block)
    end

    # Defines a new And example
    #
    #   And "I am on the home page" do
    #     visit root_path
    #   end
    #
    # @param [String] desc the description
    # @param [Hash] options the metadata for this example
    # @param block the example's code
    def And(desc=nil, options={}, &block)
      example("And #{desc}", options, &block)
    end

    # Defines a new But example
    #
    #   But "I am on the home page" do
    #     visit root_path
    #   end
    #
    # @param [String] desc the description
    # @param [Hash] options the metadata for this example
    # @param block the example's code
    def But(desc=nil, options={}, &block)
      example("But #{desc}", options, &block)
    end

    # Skip examples after the example provided.
    #
    # @param [ExampleGroup] example_group the example group of example
    # @param [Example] example the example to skip after
    #
    # @api private
    def skip_examples_after(example_group, example)
      examples = example_group.descendant_filtered_examples.flatten
      examples[examples.index(example)..-1].each do |e|
        e.metadata[:pending] = true
        e.metadata[:skipped] = true
      end
    end

    private

    # Extends an ExampleGroup with the features required for running
    # Uninhibited specs.
    #
    # @param [ExampleGroup] base the example group
    # @api private
    def self.extended(base)
      base.metadata[:feature] = true

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
