require 'ssdeep'

class Sample < ActiveRecord::Base
  has_one :data, class_name: "SampleData"
  has_many :names, class_name: "SampleName", inverse_of: :sample
  has_many :incidents, through: :names, inverse_of: :samples
  has_and_belongs_to_many :containers,
                          class_name: "Sample",
                          join_table: :containers
  has_many :droppers, through: :containers
  has_many :drops, through: :containers, foreign_key: :container_id
  has_many :cnc_traffics, inverse_of: :sample
  has_many :cncs, through: :cnc_traffics, class_name: "CommandAndControl", inverse_of: :samples

  serialize :categories, Array

  #TODO: Long process. Find streaming solution
  def similar(percentage)
    matched = {}
    others = Sample.where("id !=?", self.id)
    others.each do|other|
      match = Ssdeep::compare(self.data.ssdeep, other.data.ssdeep)
      logger.debug {"Similarity ##{self.id} <> ##{other.id}: #{match}"}
      if match >= 0 #TODO: Testing. Change it to 90. Find a streaming solution
        matched[match] ||= [] 
        matched[match]<< other
      end
    end
    return matched.sort.to_h
  end
end
