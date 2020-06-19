module ActiveRecord
  module LogDeleted
    class Configuration
      attr_reader(
        :deleted_rows_table_name,
        :log_deleted_row_function_name,
        :log_deleted_row_trigger_name,
        :support_uuids
      )

      def initialize
        @deleted_rows_table_name = :deleted_rows
        @log_deleted_row_function_name = :log_deleted_row
        @log_deleted_row_trigger_name = :log_deleted_row_trigger
        @support_uuids = true
      end

      def deleted_rows_table_name=(name)
        @deleted_rows_table_name = sanitize(name)
      end

      def log_deleted_row_function_name=(name)
        @log_deleted_row_function_name = sanitize(name)
      end

      def log_deleted_row_trigger_name=(name)
        @log_deleted_row_trigger_name = sanitize(name)
      end

      def support_uuids=(value)
        @support_uuids = value
      end

      private

      def sanitize(value)
        ::ActiveRecord::Base.sanitize_sql(value)
      end
    end
  end
end
