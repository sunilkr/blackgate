class CommandAndControl < ActiveRecord::Base
  has_many :cnc_traffics, inverse_of: :cnc
  has_many :samples, through: :cnc_traffics, inverse_of: :cncs
  
  validate :domain_or_ip_present
  validates :port, uniqueness: {scope: [:domain, :ip], message: "already exists at this server"}

  #TODO: Add PortMap for known protocols.
  def default_port?
    false
  end

  protected
  def domain_or_ip_present
    self.errors[:base]<< "Domain or IP is required." if self.domain.blank? and self.ip.blank?
  end
end
