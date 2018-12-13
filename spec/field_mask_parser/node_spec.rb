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
end
