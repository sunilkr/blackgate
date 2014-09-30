require 'ssdeep'

class Sample < ActiveRecord::Base
  has_one :data, class_name: "SampleData"
  has_many :names, class_name: "SampleName", inverse_of: :sample
  has_many :incidents, through: :names, inverse_of: :samples

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
