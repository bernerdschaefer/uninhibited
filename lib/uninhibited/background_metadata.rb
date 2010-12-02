module Uninhibited
  # Extension for RSpec::Core::Metadata to include background step definitions
  # even when running filtered actions.
  module BackgroundMetadata

    # When running a filtered set of steps, we still want to run the background
    # steps, so we need a custom method for handling this case.
    def all_apply_or_background?(predicate, filters)
      if filters[:include_background] && self[:background]
        true
      else
        rspec_all_apply?(predicate, filters.reject { |k,| k == :include_background })
      end
    end

    private

    # @param [RSpec::Core::Metadata] base rspec's metadata class
    # @api private
    def self.included(base)
      base.class_eval <<-RUBY
        alias rspec_all_apply? apply?
        alias apply? all_apply_or_background?
      RUBY
    end

  end
end
