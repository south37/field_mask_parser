module FieldMaskParser
  class Node
    attr_reader :name, :attrs, :assocs

    # @param [Symbol | NilClass] name nil when being top-level node
    # @param [<Symbol>] attrs
    # @param [Set<Node>] assocs
    def initialize(name:)
      @name   = name
      @attrs  = []
      @assocs = []
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
      { name: @name, attrs: @attrs, assocs: @assocs.map(&:to_h) }
    end
  end
end
