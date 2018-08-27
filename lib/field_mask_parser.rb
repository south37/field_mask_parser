require "field_mask_parser/dispatcher"
require "field_mask_parser/node"
require "field_mask_parser/parser"
require "field_mask_parser/version"

module FieldMaskParser
  class << self
    # @param [<String>] paths
    # @return [Node]
    def parse(paths:, root:, dispatcher: nil)
      Parser.new(paths: paths, root: root, dispatcher: dispatcher).parse
    end
  end
end
