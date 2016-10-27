require 'unicode'

module Puffery
  module Builder
    class Keyword < Base

      DEFAULT_MATCH_TYPE = :broad
      MATCH_TYPES = { broad: 'broad', phrase: 'phrase', exact: 'exact' }

      # NOTE: A list of known invalid chars can be found here:
      # http://support.google.com/adwords/bin/answer.py?hl=en&answer=53539
      INVALID_CHARS = /[,!@%^*()={};~`´’<>?\|®™²»–]/

      attribute :text, max_chars: 80, max_words: 10
      attribute :match_type, inclusion: MATCH_TYPES.values
      attribute :url, max_bytesize: 2047

      def initialize(subject)
        super(subject)
        self.match_type = DEFAULT_MATCH_TYPE
      end

      def validate
        validate_presence_of(:text, :match_type)
      end

      def match_type=(value)
        write_attribute(:match_type, MATCH_TYPES.fetch(value.downcase.to_sym))
      end

      def text=(value)
        write_attribute(:text, Keyword.normalize(value))
      end

      def self.normalize(text)
        Unicode.downcase(filter_invalid_chars(text))
      end

      def self.filter_invalid_chars(text)
        text.gsub(INVALID_CHARS, '').squeeze(' ').strip
      end

    end
  end
end
