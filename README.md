# FieldMaskParser

FieldMask parameter parser.
If you want to know more about FieldMask, please see https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'field_mask_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install field_mask_parser

## Usage

`FieldMaskParser.parse` parses FieldMask parameter and returns `FieldMaskParser::Node` object. It requires `paths` string and ActiveRecord class as `root`.

```ruby
# app/models/user.rb

# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#
class User
  has_one :profile
end
```

```ruby

# app/models/profile.rb

# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  user_id      :string           not null, indexed
#  name         :string           not null
#
class Profile
  belongs_to :user
end
```

```ruby
[1] pry> FieldMaskParser.parse(paths: ["id", "profile.name"], root: User).to_h
=>
{
  :name=>nil,
  :is_leaf=>false,
  :attrs=>[:id],
  :assocs=>[
    {
      :name=>:profile,
      :is_leaf=>false,
      :attrs=>[:name],
      :assocs=>[]
    }
  ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/south37/field_mask_parser.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
