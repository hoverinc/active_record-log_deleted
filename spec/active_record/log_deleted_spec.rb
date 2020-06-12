RSpec.describe ActiveRecord::LogDeleted do
  it "has a version number" do
    expect(ActiveRecord::LogDeleted::VERSION).not_to be nil
  end

  describe "adapter" do
    let(:connection) { ActiveRecord::Base.connection }
    let(:deleted_rows_table) { :deleted_rows }

    describe '#create_deleted_rows_table' do
      let(:expected_columns) { ["id", "created_at", "old_row_json", "primary_key", "table_name"] }

      before do
        connection.create_deleted_rows_table
      end

      it 'creates a deleted rows table with the right columns' do
        expect(connection.table_exists?(deleted_rows_table)).to be(true)
        expect(connection.columns(deleted_rows_table).map(&:name)).to match_array(expected_columns)
      end
    end

    describe '#create_log_deleted_row_function' do
      let(:log_deleted_function) { 'log_deleted_row' }
      let(:user_defined_functions_query) do
        <<~SQL
          SELECT p.proname AS function_name
          FROM pg_proc p
          LEFT JOIN pg_namespace n on p.pronamespace=n.oid
          WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
        SQL
      end

      before do
        connection.create_log_deleted_row_function
      end

      it 'creates log deleted row function' do
        expect(
          connection.query(user_defined_functions_query).first.include?(log_deleted_function)
        ).to eq(true)
      end
    end

    describe '#create_deleted_row_trigger' do
      let(:log_deleted_trigger) { 'log_deleted_row_trigger' }
      let(:trigger_query) do
        <<~SQL
          SELECT event_object_table as table_name,
                trigger_name
          FROM information_schema.triggers;
        SQL
      end

      before do
        connection.create_log_deleted_row_function
        connection.create_table(:products)
        connection.create_deleted_row_trigger(:products)
      end

      it 'creates log deleted row trigger' do
        expect(connection.query(trigger_query).first).to eq(['products', log_deleted_trigger])
      end
    end
  end
end
