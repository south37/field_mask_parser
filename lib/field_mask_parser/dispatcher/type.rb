module FieldMaskParser
  module Dispatcher
    class Type
      # @param [String] type
      def initialize(type)
        @type = type
      end

      ATTRIBUTE = self.new("Dispatcher::Type::ATTRIBUTE")
      HAS_ONE   = self.new("Dispatcher::Type::HAS_ONE")
      HAS_MANY  = self.new("Dispatcher::Type::HAS_MANY")
      UNKNOWN   = self.new("Dispatcher::Type::UNKNOWN")
    end
  end
end
