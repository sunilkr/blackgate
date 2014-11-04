require 'digest/sha1'
require 'digest/md5'
require 'ssdeep'
require 'securerandom'
require 'openssl'

class SampleData < ActiveRecord::Base
  belongs_to :sample, inverse_of: :data

  #attr_writer :data

  validates :sha1, uniqueness: true

  before_validation :preprocess
  before_save :encrypt_and_save
  after_destroy :delete_file

  def decrypted_content
    if File.exist?(self.file)
      encrypted = IO.binread(self.file)
      decipher = OpenSSL::Cipher::AES128.new(:CBC)
      decipher.decrypt
      decipher.key = [self.key].pack("H*")
      return decipher.update(encrypted) + decipher.final
    else
      self.errors.add(:file, "Cannot find data file")
      return nil
    end
  end

  def data= (content)
    @content = content
  end

  protected
  def preprocess
    #content = @data.read
    #self.mimeType = @data.content_type
    self.sha1 = Digest::SHA1.hexdigest(@content)
    self.md5 = Digest::MD5.hexdigest(@content)
    self.size = @content.length
    self.ssdeep = Ssdeep.from_string(@content)
  end
  
  def encrypt_and_save
    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.encrypt
    self.key = cipher.random_key.unpack("H*")[0]
    self.file = File.join("files", self.key) #TODO take directory from environment
    encrypted = cipher.update(@content) + cipher.final
    IO.binwrite(self.file,encrypted)
  end

  def delete_file
    File.delete(self.file) if File.exist?(self.file)
  end
end
