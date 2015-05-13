module Puffery
  module Model

    # The model who includes this module must provide attributes
    # for :remote_uid, :checksum

    def sync
      is_advertisable? up : down
    end

    # NOTE: Change name of this method to something better
    def is_advertisable?
      false
    end

    def checksum_changed?
      clear_payload!
      payload.checksum != self.checksum
    end

    def unlink
      client.unlink(self.remote_uid)
    end

    # NOTE: ska dessa har någon typ av prefix?
    def subject
      self
    end

    def namespace
      self.class.to_s
    end

    protected

    def up
      push_to_remote if checksum_changed?
    end

    def down
      if client.down(self)
        # Sätt något för att visa att den är nere. LAST_SYNCED_AT?
      end
    end

    def client
      @client ||= Puffery::Client.new
    end

    def set_remote_uid(uid)
      update_column(remote_uid: uid)
    end

    def push_to_remote
      if response = client.up(self)
        set_remote_uid(response[:uid])
      end
    end

    def clear_payload!
      @payload = nil
    end

    def payload
      @payload ||= build_payload
    end

    def build_payload
      Puffery.build_payload(subject, namespace)
    end

  end
end
