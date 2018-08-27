module FieldMaskParser
  class Parser
    # HashBuilder build nested hash from paths (string array).
    # ex.
    # param: ["id", "facebook_uid", "detail.id", "detail.email"]
    # return: {:id=>{}, :facebook_uid=>{}, :detail=>{:id=>{}, :email=>{}}}
    class HashBuilder
      class << self
        # @param [<String>] paths
        # @return [{ Symbol => Hash }]
        def build(paths)
          h = {}
          paths.each do |path|
            deep_push!(h, path.split('.').map(&:strip).map(&:to_sym))
          end
          h
        end

      private

        # @param [Hash] h
        # @param [<String>] field_list
        def deep_push!(h, field_list)
          if field_list.size < 1
            # Do nothing
            return
          end
          f = field_list.first
          if !h[f]
            h[f] = {}
          end
          deep_push!(h[f], field_list[1..-1])
        end
      end
    end

    # @param [<String>] paths
    def initialize(paths:, root:, dispatcher: nil)
      @attrs_or_assocs = HashBuilder.build(paths)
      @root            = root
      @dispatcher      = dispatcher || Dispatcher::ActiveRecordDispatcher.new
    end

    # @reutrn [Node]
    def parse
      r = Node.new(name: nil)
      set_attrs_and_assocs!(r, @attrs_or_assocs, @root)
      r
    end

  private

    # @param [Node] node
    # @param [Hash] attrs_or_assocs
    # @param [Class] klass inheriting ActiveRecord::Base
    def set_attrs_and_assocs!(node, attrs_or_assocs, klass)
      attrs_or_assocs.each do |name, _attrs_or_assocs|
        case @dispatcher.dispatch(klass, name)
        when Dispatcher::Type::ATTRIBUTE
          node.push_attr(name)
        when Dispatcher::Type::ASSOCIATION
          n = Node.new(name: name)
          node.push_assoc(n)
          if _attrs_or_assocs.size > 0
            _klass = get_assoc_klass(klass, name)
            set_attrs_and_assocs!(n, _attrs_or_assocs, _klass)
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
      parent.reflect_on_association(name).klass
    end
  end
end
