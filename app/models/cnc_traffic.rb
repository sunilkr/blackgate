class CncTraffic < ActiveRecord::Base
  belongs_to :sample, inverse_of: :cnc_traffics
  belongs_to :cnc, class_name: "CommandAndControl", foreign_key: "command_and_control_id", inverse_of: :cnc_traffics
  
  def full_url
    self.cnc.protocol.downcase + "://" + 
      ((self.cnc.domain) ? self.cnc.domain : self.cnc.ip)+
      ((self.cnc.default_port?)? '' : ":#{self.cnc.port}")+
      ((self.url.starts_with?('/'))? self.url : ("/" + self.url))
  end

end
