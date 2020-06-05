# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module PostgreSQLAdapter

      def create_deleted_rows_table
        create_table deleted_rows_table do |t|
          t.datetime :created_at, comment: 'The datetime at which the record was created.'
          t.text :old_row_json, comment: 'JSON with the entire row that was hard deleted.'
          t.string :primary_key, comment: 'The primary key of the row which was hard deleted.'
          t.string :table_name, limit: 255, comment: 'The table name from which the row was hard deleted.'
        end
      end

      def create_deleted_row_trigger(table_name)
        reversible do |direction|
          direction.up do
            execute <<~SQL
              create trigger #{log_deleted_row_trigger} after delete on #{ActiveRecord::Base.sanitize_sql(table_name)} for each row execute procedure #{function}();
            SQL
          end

          direction.down do
            execute <<~SQL
              drop trigger if exists #{log_deleted_row_trigger} on #{ActiveRecord::Base.sanitize_sql(table_name)};
            SQL
          end
        end
      end

      def create_log_deleted_row_function
        reversible do |direction|
          direction.up do
            execute <<-SQL
              CREATE OR REPLACE FUNCTION log_deleted_row() RETURNS trigger AS $$
                BEGIN
                  INSERT INTO
                    deleted_rows(table_name, primary_key, old_row_json, created_at)
                      VALUES (TG_TABLE_NAME, OLD.id::varchar, ROW_TO_JSON(OLD), now());
                  RETURN OLD;
                END;
              $$ LANGUAGE plpgsql;
            SQL
          end

          direction.down do
            execute "DROP FUNCTION #{function}"
          end
        end
      end

      private

      def log_deleted_row_trigger
        ActiveRecord::Base.sanitize_sql('log_deleted_row_trigger')
      end

      def function
        ActiveRecord::Base.sanitize_sql('log_deleted_row')
      end

      def deleted_rows_table
        ActiveRecord::Base.sanitize_sql('deleted_rows')
      end
    end
  end
end
