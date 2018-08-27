module FieldMaskParser
  module Dispatcher
    class Type
      # @param [String] type
      def initialize(type)
        @type = type
      end

      ATTRIBUTE   = self.new("Dispatcher::Type::ATTRIBUTE")
      ASSOCIATION = self.new("Dispatcher::Type::ASSOCIATION")
      UNKNOWN     = self.new("Dispatcher::Type::UNKNOWN")
    end
  end
end
