# ActiveRecord::LogDeleted

Our data team needs to have logs of deleted rows. To do this, we historically have copy pasted some raw SQL from migration to migration. This gem exposes methods in ActiveRecord migrations to create the deleted row triggers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-log_deleted'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_record-log_deleted

## Usage

### Configuration

To override defaults, add an initializer:

```ruby
# config/initializers/active_record-log_deleted.rb
ActiveRecord::LogDeleted.configure do |config|
    config.deleted_rows_table_name = :deleted_rows
    config.log_deleted_row_function_name = :log_deleted_row
    config.log_deleted_row_trigger_name = :log_deleted_row_trigger
end
```

### Create the deleted rows table
```ruby
class CreateDeletedRowsTable < ActiveRecord::Migration[6.0]
  def change
    create_deleted_rows_table
  end
end
```

### Create the log deleted row function
```ruby
class CreateLogDeletedRowFunction < ActiveRecord::Migration[6.0]
  def change
    create_log_deleted_row_function
  end
end
```

### Create the deleted row trigger
```ruby
class CreateDeletedRowTrigger < ActiveRecord::Migration[6.0]
  def change
    create_deleted_row_trigger(:table_name)
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/active_record-log_deleted.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
