class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.date    :reportedOn
      t.string  :group
      t.string  :categories
      t.string  :status
      t.date    :analyzedOn
      t.string  :comment
      
      t.timestamps
    end
  end
end
