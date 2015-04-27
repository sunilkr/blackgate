class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.references :sample, index: true
      t.integer :container_id, index: true
    end
  end
end
