require 'field_mask_parser/parser/deep_hash_builder'
require 'field_mask_parser/parser/deep_hash_node'

module FieldMaskParser
  class Parser
    # @param [<String>] paths
    def initialize(paths:, root:, dispatcher: nil)
      @attrs_or_assocs = DeepHashBuilder.build(paths)
      @root            = root
      @dispatcher      = dispatcher || Dispatcher::ActiveRecordDispatcher.new
    end

    # @reutrn [Node]
    def parse
      r = Node.new(name: nil, is_leaf: false, klass: @root)
      set_attrs_and_assocs!(r, @attrs_or_assocs, @root)
      r
    end

  private

    # @param [Node] node
    # @param [{ Symbol => DeepHashNode }] attrs_or_assocs
    # @param [Class] klass inheriting ActiveRecord::Base
    def set_attrs_and_assocs!(node, attrs_or_assocs, klass)
      attrs_or_assocs.each do |name, dhn|
        case @dispatcher.dispatch(klass, name)
        when Dispatcher::Type::ATTRIBUTE
          # NOTE: If dhn.is_leaf is false, it is invalid. But ignore it now.
          node.push_attr(name)
        when Dispatcher::Type::ASSOCIATION
          _klass = get_assoc_klass(klass, name)
          n = Node.new(name: name, is_leaf: dhn.is_leaf, klass: _klass)
          node.push_assoc(n)
          if dhn.children.size > 0
            set_attrs_and_assocs!(n, dhn.children, _klass)
          end
        when Dispatcher::Type::UNKNOWN
          # Ignore invalid field
        else
          raise "invalid type (#{@dispatcher.dispatch(klass, name)}) with klass (#{klass}) and name (#{name})"
        end
      end
    end

    # @param [Class] parent
    # @param [Symbol] name
    # @return [Class]
    def get_assoc_klass(parent, name)
      assocition = parent.reflect_on_association(name)
      if !assocition
        raise "#{parent} does not have #{name} assocition!"
      end
      assocition.klass
    end
  end
end
