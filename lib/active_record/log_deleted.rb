# frozen_string_literal: true

require "active_record"
require "active_record/schema_dumper"
require "active_record/connection_adapters/postgresql/schema_statements"
require "active_record/connection_adapters/postgresql_adapter"
require "active_support/lazy_load_hooks"

require 'active_record/log_deleted/version'
require 'active_record/log_deleted/configuration'
require 'active_record/log_deleted/postgresql_adapter'
require 'active_record/log_deleted/command_recorder'

module ActiveRecord
  module LogDeleted
    def self.configuration
      @configuration ||= ::ActiveRecord::LogDeleted::Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend ActiveRecord::LogDeleted::PostgreSQLAdapter
  ActiveRecord::Migration::CommandRecorder.prepend ActiveRecord::LogDeleted::CommandRecorder
end
