class CreateSampleReorts < ActiveRecord::Migration
  def change
    create_table :sample_reorts do |t|
      t.references :sample, index: true
      t.references :report, index: true
    end
  end
end
