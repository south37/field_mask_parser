module FieldMaskParser
  class Parser
    class DeepHashNode
      attr_accessor :is_leaf
      attr_reader :children

      def initialize
        @is_leaf  = false
        @children = {}
      end

      # @param [Symbol] field
      # @param [DeepHashNode] n
      def push_child(field, n)
        @children[field] = n
      end

      # @param [DeepHashNode] other
      # @reutrn [bool]
      def ==(other)
        is_leaf == other.is_leaf && children == other.children
      end
    end
  end
end
