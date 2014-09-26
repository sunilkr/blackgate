class Sample < ActiveRecord::Base
  has_one :data, class_name: "SampleData"
  has_many :names, class_name: "SampleName", inverse_of: :sample
  has_many :incidents, through: :names, inverse_of: :samples

  serialize :categories, Array
end
