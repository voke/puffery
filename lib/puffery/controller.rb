module Puffery
  class Controller

    extend Forwardable
    def_delegators :model, :remote_uid, :checksum

    DEFAULT_OPTIONS = {
      valid: :advertise?,
      namespace: -> model { model.class.name.downcase }
    }

    attr_accessor :model, :options

    def initialize(model, options = {})
      self.model = model
      self.options = DEFAULT_OPTIONS.merge(options)
    end

    def namespace
      @namespace ||= compute_option(options[:namespace])
    end

    def valid_advertisement?
      @valid_advertisement ||= compute_option(options[:valid])
    end

    def subject
      @subject ||= compute_option(options[:subject])
    end

    def compute_option(value)
      case value
      when Proc
        value.arity.zero? ? value.call : value.call(model)
      when Symbol
        model.public_send(value)
      else
        value
      end
    end

    def sync
      valid_advertisement? ? up : down
    end

    def checksum_changed?
      clear_payload!
      payload.checksum != self.checksum
    end

    def unlink
      if client.unlink(remote_uid)
        nullify_remote_uid if model.persisted?
      end
    end

    def payload
      @payload ||= build_payload
    end

    def exists_on_remote?
      !!remote_uid
    end

    protected

    def up
      push_to_remote if checksum_changed?
    end

    def down
      if exists_on_remote? && client.down(remote_uid)
        set_checksum(nil)
        true
      end
    end

    def client
      @client ||= Puffery::Client.new
    end

    def nullify_remote_uid
      model.update_column(:remote_uid, nil)
    end

    def set_remote_uid(uid)
      model.update_column(:remote_uid, uid)
    end

    def set_checksum(new_checksum)
      model.update_column(:checksum, new_checksum)
    end

    def push_to_remote
      if data = client.push(remote_uid, payload, active: valid_advertisement?)
        set_remote_uid(data['uid']) unless exists_on_remote?
        set_checksum(payload.checksum)
        true
      end
    end

    def clear_payload!
      @payload = nil
    end

    def build_payload
      Puffery.build_payload(subject, namespace)
    end

  end
end
