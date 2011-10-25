module RSpec
  module Core
    module Hooks
      def spies(*args, &block)
        scope, options = scope_and_options_from(*args)
        hooks[:before][scope] << BeforeHook.new(options, &block)
      end
      def act(*args, &block)
        scope, options = scope_and_options_from(*args)
        hooks[:after][scope] << AfterHook.new(options, &block)
      end
      alias :cause :act
    end
  end
  module Mocks
    module Methods
      alias_method :should_have_received, :should_receive
      alias_method :should_not_have_received, :should_not_receive
    end
  end
end

#alias :context :describe

RSpec.configure do |config|
  config.alias_example_to :observe
end
