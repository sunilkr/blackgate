class Incident < ActiveRecord::Base
  has_many :sample_names, inverse_of: :incident
  has_many :samples, through: :sample_names, inverse_of: :incidents
end
