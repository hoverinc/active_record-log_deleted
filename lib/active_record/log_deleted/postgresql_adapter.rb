# frozen_string_literal: true

module ActiveRecord
  module LogDeleted
    module PostgreSQLAdapter
      def create_deleted_rows_table
        create_table deleted_rows_table_name do |t|
          t.datetime :created_at, comment: 'The datetime at which the record was created.'
          t.text :old_row_json, comment: 'JSON with the entire row that was hard deleted.'
          t.string :primary_key, comment: 'The primary key of the row which was hard deleted.'
          t.string :table_name, limit: 255, comment: 'The table name from which the row was hard deleted.'
        end
      end

      def drop_deleted_rows_table
        drop_table deleted_rows_table_name
      end

      def create_log_deleted_row_function
        execute <<-SQL
          CREATE OR REPLACE FUNCTION #{log_deleted_row_function_name}() RETURNS trigger AS $$
            BEGIN
              INSERT INTO
                deleted_rows(table_name, primary_key, old_row_json, created_at)
                  VALUES (TG_TABLE_NAME, OLD.id::varchar, ROW_TO_JSON(OLD), now());
              RETURN OLD;
            END;
          $$ LANGUAGE plpgsql;
        SQL
      end

      def drop_log_deleted_row_function
        execute "DROP FUNCTION #{log_deleted_row_function_name};"
      end

      def create_deleted_row_trigger(table_name)
        execute <<~SQL
          create trigger #{log_deleted_row_trigger_name} after delete on #{ActiveRecord::Base.sanitize_sql(table_name)} for each row execute procedure #{log_deleted_row_function_name}();
        SQL
      end

      def drop_deleted_row_trigger(table_name)
        execute <<~SQL
          drop trigger if exists #{log_deleted_row_trigger_name} on #{ActiveRecord::Base.sanitize_sql(table_name)};
        SQL
      end

      private

      def log_deleted_row_trigger_name
        configuration.log_deleted_row_trigger_name
      end

      def log_deleted_row_function_name
        configuration.log_deleted_row_function_name
      end

      def deleted_rows_table_name
        configuration.deleted_rows_table_name
      end

      def configuration
        ::ActiveRecord::LogDeleted.configuration
      end
    end
  end
end
