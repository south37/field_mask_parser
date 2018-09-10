module FieldMaskParser
  class Node
    attr_reader :name, :is_leaf, :klass, :attrs, :assocs

    # @param [Symbol | NilClass] name nil when being top-level node
    # @param [bool] is_leaf
    # @param [<Symbol>] attrs
    # @param [Set<Node>] assocs
    # @param [ActiveRecord::Base] klass
    def initialize(name:, is_leaf:, klass:)
      @name    = name
      @is_leaf = is_leaf
      @klass   = klass
      @attrs   = []
      @assocs  = []
    end

    # @param [Symbol] f
    def push_attr(f)
      @attrs.push(f)
    end

    # @param [Node] n
    def push_assoc(n)
      @assocs.push(n)
    end

    def to_h
      {
        name:    @name,
        is_leaf: @is_leaf,
        klass:   @klass,
        attrs:   @attrs,
        assocs:  @assocs.map(&:to_h)
      }
    end
  end
end
