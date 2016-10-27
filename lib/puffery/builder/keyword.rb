require 'unicode'

module Puffery
  module Builder
    class Keyword < Base

      DEFAULT_MATCH_TYPE = :broad
      MATCH_TYPES = { broad: 'broad', phrase: 'phrase', exact: 'exact' }
      MAX_CHARS = 80
      MAX_WORDS = 10
      MAX_BYTESIZE = 2047

      # NOTE: A list of known invalid chars can be found here:
      # http://support.google.com/adwords/bin/answer.py?hl=en&answer=53539
      INVALID_CHARS = /[,!@%^*()={};~`´’<>?\|®™²»–]/

      attribute :text, max_chars: MAX_CHARS, max_words: MAX_WORDS
      attribute :match_type, inclusion: MATCH_TYPES.values
      attribute :url, max_bytesize: MAX_BYTESIZE

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
        text.gsub(INVALID_CHARS, '').squeeze(' ').strip if text
      end

    end
  end
end
