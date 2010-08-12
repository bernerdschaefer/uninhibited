module Uninhibited
  module BackgroundMetadata
    def self.included(base)
      base.class_eval <<-RUBY
        alias rspec_all_apply? all_apply?
        alias all_apply? all_apply_or_background?
      RUBY
    end

    # When running a filtered set of steps, we still want to run the background
    # steps, so we need a custom method for handling this case.
    def all_apply_or_background?(filters)
      if filters[:include_background] && self[:background]
        true
      else
        rspec_all_apply?(filters.reject { |k,| k == :include_background })
      end
    end
  end
end
