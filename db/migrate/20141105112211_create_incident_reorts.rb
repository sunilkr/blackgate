class CreateIncidentReorts < ActiveRecord::Migration
  def change
    create_table :incident_reorts do |t|
      t.references :incident, index: true
      t.references :report, index: true
    end
  end
end
