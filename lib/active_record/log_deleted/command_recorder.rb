# frozen_string_literal: true

module ActiveRecord
  module LogDeleted
    module CommandRecorder
      def create_deleted_rows_table
        record(:create_deleted_rows_table, [])
      end

      def invert_create_deleted_rows_table(*args)
        [:drop_table, :deleted_rows]
      end

      def create_log_deleted_row_function
        record(:create_log_deleted_row_function, [])
      end

      def invert_create_log_deleted_row_function(*args)
        [:drop_log_deleted_row_function]
      end

      def create_deleted_row_trigger(name)
        record(:create_deleted_row_trigger, name)
      end

      def invert_create_deleted_row_trigger(name)
        [:drop_deleted_row_trigger, name]
      end
    end
  end
end
