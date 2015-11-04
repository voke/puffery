class Payload < Hash

  def initialize(other_hash)
    super
    other_hash.each_pair do |key, value|
      self[key] = value
    end
  end

  def checksum
    @checksum ||= Digest::MD5.hexdigest(Marshal.dump(self))
  end

end
