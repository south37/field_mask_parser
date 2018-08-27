module FieldMaskParser
  module Dispatcher
    class Base
      # @param [klass] inheriting ActiveRecord::Base
      # @param [name]
      # @return [Dispatcher::Type]
      def dispatch(klass, name)
        raise NotImplementedError.new("#{self.class.name}#dispatch is an abstract method.")
      end
    end
  end
end
