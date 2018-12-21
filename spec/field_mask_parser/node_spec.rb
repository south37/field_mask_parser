require 'spec_helper'

describe FieldMaskParser do
  describe "#to_paths" do
    it "returns list" do
      node = FieldMaskParser.parse(
        paths: [
          "registered_at",
          "id",
          "profile",
          "profile.name",
          "profile.id",
          "items.type",
          "items.id",
        ],
        root: User
      )
      expect(node.to_paths).to eq [
        "id",
        "items.id",
        "items.type",
        "profile.id",
        "profile.name",
        "registered_at",
      ]
    end
  end

  describe "#==" do
    it "returns equality" do
      node = FieldMaskParser.parse(
        paths: [
          "id",
          "profile.id",
        ],
        root: User
      )
      expect(node).to eq node

      node2 = FieldMaskParser.parse(
        paths: [
          "id",
          "profile.id",
        ],
        root: User
      )
      expect(node).to eq node2

      node3 = FieldMaskParser.parse(
        paths: [
          "id",
        ],
        root: User
      )
      expect(node).not_to eq node3

      expect(node).not_to eq 1
    end
  end
end
