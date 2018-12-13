require 'spec_helper'

describe FieldMaskParser do
  describe ".parse" do
    it "parses paths and generates node" do
      expect(FieldMaskParser.parse(paths: [""], root: User).to_h).to eq({
        name:       nil,
        is_leaf:    false,
        klass:      User,
        attrs:      [],
        has_ones:   [],
        has_manies: [],
      })

      expect(FieldMaskParser.parse(paths: ["id"], root: User).to_h).to eq({
        name:       nil,
        is_leaf:    false,
        klass:      User,
        attrs:      [:id],
        has_ones:   [],
        has_manies: [],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile.name"], root: User).to_h).to eq({
        name:       nil,
        is_leaf:    false,
        klass:      User,
        attrs:      [:id],
        has_ones:   [
          {
            name:       :profile,
            is_leaf:    false,
            klass:      Profile,
            attrs:      [:name],
            has_ones:   [],
            has_manies: [],
          }
        ],
        has_manies: [],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile"], root: User).to_h).to eq({
        name:        nil,
        is_leaf:     false,
        klass:       User,
        attrs:       [:id],
        has_ones:    [
          {
            name:       :profile,
            is_leaf:    true,
            klass:      Profile,
            attrs:      [],
            has_ones:   [],
            has_manies: [],
          }
        ],
        has_manies: [],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile", "profile.name"], root: User).to_h).to eq({
        name:        nil,
        is_leaf:     false,
        klass:       User,
        attrs:       [:id],
        has_ones:    [
          {
            name:       :profile,
            is_leaf:    true,
            klass:      Profile,
            attrs:      [:name],
            has_ones:   [],
            has_manies: [],
          }
        ],
        has_manies:  [],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile", "profile.name", "items.type"], root: User).to_h).to eq({
        name:        nil,
        is_leaf:     false,
        klass:       User,
        attrs:       [:id],
        has_ones:    [
          {
            name:       :profile,
            is_leaf:    true,
            klass:      Profile,
            attrs:      [:name],
            has_ones:   [],
            has_manies: [],
          }
        ],
        has_manies:  [
          {
            name:       :items,
            is_leaf:    false,
            klass:      Item,
            attrs:      [:type],
            has_ones:   [],
            has_manies: [],
          }
        ],
      })
    end
  end
end
