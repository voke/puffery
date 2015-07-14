module Puffery
  class Payload

    attr_accessor :raw

    def initialize(raw)
      self.raw = raw
    end

    def checksum
      @checksum ||= Digest::MD5.hexdigest(Marshal.dump(raw))
    end

  end
end
