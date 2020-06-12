 # frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveRecord::LogDeleted::CommandRecorder do
  let(:connection) { ActiveRecord::Base.connection }
  let(:deleted_rows_table) { :deleted_rows }
  let(:log_deleted_function) { 'log_deleted_row' }
  let(:log_deleted_trigger) { 'log_deleted_row_trigger' }

  let(:user_defined_functions_query) do
    <<~SQL
      SELECT p.proname AS function_name
      FROM pg_proc p
      LEFT JOIN pg_namespace n on p.pronamespace=n.oid
      WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
    SQL
  end
  let(:trigger_query) do
    <<~SQL
      SELECT event_object_table as table_name,
            trigger_name
      FROM information_schema.triggers;
    SQL
  end

  it "reverts create_deleted_rows_table" do
    migration = build_migration { create_deleted_rows_table }

    migration.migrate(:up)
    expect(connection.table_exists?(deleted_rows_table)).to be(true)

    migration.migrate(:down)
    expect(connection.table_exists?(deleted_rows_table)).to be(false)
  end

  it "reverts create_log_deleted_row_function" do
    migration = build_migration { create_log_deleted_row_function }

    migration.migrate(:up)
    expect(
      connection.query(user_defined_functions_query).first.include?(log_deleted_function)
    ).to eq(true)

    migration.migrate(:down)
    expect(connection.query(user_defined_functions_query)).to be_empty
  end

  it "reverts create_deleted_row_trigger" do
    connection.create_log_deleted_row_function
    connection.create_table(:products)

    migration = build_migration do
      create_deleted_row_trigger(:products)
    end

    migration.migrate(:up)
    expect(connection.query(trigger_query).first).to eq(['products', log_deleted_trigger])

    migration.migrate(:down)
    expect(connection.query(trigger_query)).to be_empty
  end
end
