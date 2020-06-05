require "active_record/log_deleted/version"
require "active_record/connection_adapters/postgresql_adapter"
require "active_record/log_deleted/postgresql_adapter"

module ActiveRecord
  module LogDeleted
    class Error < StandardError; end
  end
end



ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend ActiveRecord::LogDeleted::PostgreSQLAdapter
end
