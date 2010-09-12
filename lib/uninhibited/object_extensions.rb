module Uninhibited

  # Extension methods to be included in the global object space
  # for defining features.
  module ObjectExtensions

    # Defines a new feature:
    #
    #   Feature "User signs in" do
    #     Given "..."
    #     When  "..."
    #     Then  "..."
    #   end
    #
    # @param args the description, metadata, etc. as RSpec's #describe method
    # takes.
    # @param example_group_block the block to be executed within the feature
    #
    # @return [Feature] the new example group
    def Feature(*args, &example_group_block)
      args << {} unless args.last.is_a?(Hash)
      args.last.update(:feature => true)
      describe(*args, &example_group_block)
    end

  end

end
