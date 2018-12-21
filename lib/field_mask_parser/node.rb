module FieldMaskParser
  class Node
    attr_reader :name, :is_leaf, :klass, :attrs, :has_ones, :has_manies

    # @param [Symbol | NilClass] name nil when being top-level node
    # @param [bool] is_leaf
    # @param [ActiveRecord::Base] klass
    def initialize(name:, is_leaf:, klass:)
      @name       = name
      @is_leaf    = is_leaf
      @klass      = klass
      @attrs      = []
      @has_ones   = []
      @has_manies = []
    end

    # @param [Symbol] f
    def push_attr(f)
      @attrs.push(f)
    end

    # @param [Node] n
    def push_has_one(n)
      @has_ones.push(n)
    end

    # @param [Node] n
    def push_has_many(n)
      @has_manies.push(n)
    end

    def assocs
      has_ones + has_manies
    end

    def to_h
      {
        name:       @name,
        is_leaf:    @is_leaf,
        klass:      @klass,
        attrs:      @attrs,
        has_ones:   @has_ones.map(&:to_h),
        has_manies: @has_manies.map(&:to_h),
      }
    end

    def to_paths(prefix: [], sort: true)
      r = []
      attrs.each do |attr|
        r << (prefix + [attr]).join(".")
      end
      assocs.each do |assoc|
        r += assoc.to_paths(prefix: prefix + [assoc.name], sort: false)
      end
      r.sort! if sort
      r
    end

    def ==(other)
      self.class == other.class &&
        self.to_paths == other.to_paths
    end
  end
end
