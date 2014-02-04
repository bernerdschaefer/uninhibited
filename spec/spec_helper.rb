require File.expand_path('../../lib/uninhibited', __FILE__)

def stub_world
  @stub_world = RSpec::Core::World.new
  config = @stub_world.instance_variable_get(:@configuration)
  config.stub(:color_enabled?) { false }
  @stub_world
end

module MissingFileShim
  def find_failed_line(backtrace, path)
    if path
      super
    end
  end
end

RSpec::Core::Formatters::DocumentationFormatter.module_eval { include MissingFileShim }

RSpec.configure do |c|
  c.before(:each) do
    @real_world = RSpec.world
    RSpec.instance_variable_set(:@world, stub_world)
  end
  c.after(:each) do
    RSpec.instance_variable_set(:@world, @real_world)
  end
end
