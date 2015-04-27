class DropContainersTables < ActiveRecord::Migration
  def change
    drop_table "containers_tables"
  end
end
