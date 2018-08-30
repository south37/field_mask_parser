require 'spec_helper'

describe FieldMaskParser::Parser::DeepHashBuilder do
  # alias
  DeepHashBuilder = FieldMaskParser::Parser::DeepHashBuilder
  DeepHashNode    = FieldMaskParser::Parser::DeepHashNode

  describe ".build" do
    it "parses paths and generates node" do
      expect(DeepHashBuilder.build([""])).to eq({})

      expect(DeepHashBuilder.build(["id"])).to eq({
        id: node(is_leaf: true, children: {})
      })

      expect(DeepHashBuilder.build(["id", "profile.name"])).to eq({
        id: node(is_leaf: true, children: {}),
        profile: node(is_leaf: false, children: {
          name: node(is_leaf: true, children: {})
        }),
      })

      expect(DeepHashBuilder.build(["id", "profile", "profile.name"])).to eq({
        id: node(is_leaf: true, children: {}),
        profile: node(is_leaf: true, children: {
          name: node(is_leaf: true, children: {})
        }),
      })
    end
  end

  def node(is_leaf:, children:)
    n = DeepHashNode.new
    n.is_leaf = is_leaf
    children.each { |field, c| n.push_child(field, c) }
    n
  end
end
