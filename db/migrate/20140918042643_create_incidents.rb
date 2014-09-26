class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :title
      t.string :description
      t.date   :reportedOn
      t.string :reportedBy
      t.string :status

      t.timestamps
    end
  end
end
