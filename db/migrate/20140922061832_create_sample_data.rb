class CreateSampleData < ActiveRecord::Migration
  def change
    create_table :sample_data do |t|
      t.references :sample, index: true
      t.string :sha1
      t.string :md5
      t.string :ssdeep
      t.string :mimeType
      t.integer :size
      t.string :key
      t.string :file
      t.timestamps
    end
  end
end
