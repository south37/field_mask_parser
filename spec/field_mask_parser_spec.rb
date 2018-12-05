require 'spec_helper'
require 'active_record'

describe FieldMaskParser do
  describe ".parse" do
    class User < ActiveRecord::Base
      class << self
        def attribute_names
          ["id"]
        end
      end

      has_one :profile
      has_many :items
    end

    class Profile < ActiveRecord::Base
      class << self
        def attribute_names
          ["id", "user_id", "name"]
        end
      end

      belongs_to :user
    end

    class Item < ActiveRecord::Base
      class << self
        def attribute_names
          ["id", "type"]
        end
      end

      belongs_to :user
    end

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
