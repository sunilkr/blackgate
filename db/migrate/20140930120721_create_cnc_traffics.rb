class CreateCncTraffics < ActiveRecord::Migration
  def change
    create_table :cnc_traffics do |t|
      t.references :sample, index: true
      t.references :command_and_control, index: true
      t.date :accessedOn
      t.string :url
      t.integer :size
      t.string :dataType
      t.string :data

      t.timestamps
    end
  end
end
