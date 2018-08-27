module FieldMaskParser
  module Dispatcher
    class ActiveRecordDispatcher < Base
      # @param [klass] inheriting ActiveRecord::Base
      # @param [Symbol] name
      # @return [Dispatcher::Type]
      def dispatch(klass, name)
        if klass.attribute_names.include?(name.to_s)
          Type::ATTRIBUTE
        elsif klass.reflect_on_association(name)
          Type::ASSOCIATION
        else
          Type::UNKNOWN
        end
      end
    end
  end
end
