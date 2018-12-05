module FieldMaskParser
  module Dispatcher
    class ActiveRecordDispatcher < Base
      # @param [klass] inheriting ActiveRecord::Base
      # @param [Symbol] name
      # @return [Dispatcher::Type]
      def dispatch(klass, name)
        if klass.attribute_names.include?(name.to_s)
          Type::ATTRIBUTE
        elsif (assoc = klass.reflect_on_association(name))
          case assoc
          when ActiveRecord::Reflection::HasOneReflection
            Type::HAS_ONE
          when ActiveRecord::Reflection::HasManyReflection
            Type::HAS_MANY
          else
            raise "invalid association!"
          end
        else
          Type::UNKNOWN
        end
      end
    end
  end
end
