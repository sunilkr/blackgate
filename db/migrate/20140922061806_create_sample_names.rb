class CreateSampleNames < ActiveRecord::Migration
  def change
    create_table :sample_names do |t|
      t.references :sample, index: true
      t.references :incident, index: true
      t.string :name
      t.date :reportedOn

      t.timestamps
    end
  end
end
