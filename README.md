# ActiveRecord::EnumTranslation

[![test](https://github.com/r7kamura/activerecord-enum_translation/actions/workflows/test.yml/badge.svg)](https://github.com/r7kamura/activerecord-enum_translation/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/activerecord-enum_translation.svg)](https://rubygems.org/gems/activerecord-enum_translation)

Provides integration between ActiveRecord::Enum and I18n.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-enum_translation'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord-enum_translation

## Usage

Include `ActiveRecord::EnumTranslation`:

```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActiveRecord::EnumTranslation
end
```

Define enum:

```ruby
class User < ApplicationRecord
  enum status: %i[active inactive]
end
```

Add translations in your locale files:

```yaml
ja:
  activerecord:
    attributes:
      user:
        status:
          active: 利用中
          inactive: 停止中
```

Get the translation by `human_enum_name_for`:

```ruby
user = User.new(status: :active)
user.human_enum_name_for(:status) #=> "利用中"
```

This gem also provides `human_enum_name_reader_for`:

```ruby
class User < ApplicationRecord
  enum status: %i[active inactive]
  human_enum_name_reader_for :status
end
```

Finally you can use `human_enum_name_for_status`:

```ruby
user = User.new(status: :active)
user.human_enum_name_for_status #=> "利用中"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r7kamura/activerecord-enum_translation.

