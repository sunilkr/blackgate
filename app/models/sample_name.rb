class SampleName < ActiveRecord::Base
  belongs_to :sample, inverse_of: :names
  belongs_to :incident, inverse_of: :sample_names

  validates :name, uniqueness: {scope: [:sample_id, :incident_id], message: "already exists"}  
end
