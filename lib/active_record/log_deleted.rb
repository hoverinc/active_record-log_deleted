require "active_record/log_deleted/version"
require "active_record/log_deleted/configuration"
require "active_record/connection_adapters/postgresql_adapter"
require "active_record/log_deleted/postgresql_adapter"
require "active_record/log_deleted/command_recorder"

module ActiveRecord
  module LogDeleted
    def self.configuration
      @configuration ||= ::ActiveRecord::LogDeleted::Configuration.new
    end

    def self.configure
      yield(@configuration)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend ActiveRecord::LogDeleted::PostgreSQLAdapter
  ActiveRecord::Migration::CommandRecorder.prepend ActiveRecord::LogDeleted::CommandRecorder
end
