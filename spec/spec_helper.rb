require 'field_mask_parser'
require 'active_record'

# NOTE: Prepare test classes
class User < ActiveRecord::Base
  class << self
    def attribute_names
      ["id", "registered_at"]
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
