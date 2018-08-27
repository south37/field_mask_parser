require 'active_record'
require 'field_mask_parser'

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
        name:   nil,
        attrs:  [],
        assocs: [],
      })

      expect(FieldMaskParser.parse(paths: ["id"], root: User).to_h).to eq({
        name:   nil,
        attrs:  [:id],
        assocs: [],
      })

      expect(FieldMaskParser.parse(paths: ["id", "profile.name"], root: User).to_h).to eq({
        name:   nil,
        attrs:  [:id],
        assocs: [
          {
            name:   :profile,
            attrs:  [:name],
            assocs: [],
          }
        ],
      })
    end
  end
end
