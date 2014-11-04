class CreateCommandAndControls < ActiveRecord::Migration
  def change
    create_table :command_and_controls do |t|
      t.string :domain
      t.string :ip
      t.string :protocol
      t.integer :port
      t.date :first_access
      t.date :last_access

      t.timestamps
    end
  end
end
