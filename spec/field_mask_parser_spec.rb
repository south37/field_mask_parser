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
    end

    class Profile < ActiveRecord::Base
      class << self
        def attribute_names
          ["id", "user_id", "name"]
        end
      end

      belongs_to :user
    end

    it "parses paths and generates node" do
      expect(FieldMaskParser.parse(paths: [""], root: User).to_h).to eq({
        name:    nil,
        is_leaf: false,
        klass:   User,
        attrs:   [],
        assocs:  [],
      })

      expect(FieldMaskParser.parse(paths: ["id"], root: User).to_h).to eq({
        name:    nil,
        is_leaf: false,
        klass:   User,
        attrs:   [:id],
        assocs:  [],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile.name"], root: User).to_h).to eq({
        name:    nil,
        is_leaf: false,
        klass:   User,
        attrs:   [:id],
        assocs:  [
          {
            name:    :profile,
            is_leaf: false,
            klass:   Profile,
            attrs:   [:name],
            assocs:  [],
          }
        ],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile"], root: User).to_h).to eq({
        name:    nil,
        is_leaf: false,
        klass:   User,
        attrs:   [:id],
        assocs:  [
          {
            name:    :profile,
            is_leaf: true,
            klass:   Profile,
            attrs:   [],
            assocs:  [],
          }
        ],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile", "profile.name"], root: User).to_h).to eq({
        name:    nil,
        is_leaf: false,
        klass:   User,
        attrs:   [:id],
        assocs:  [
          {
            name:    :profile,
            is_leaf: true,
            klass:   Profile,
            attrs:   [:name],
            assocs:  [],
          }
        ],
      })
    end
  end
end
