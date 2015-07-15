module Puffery
  module Builder
    class Keyword < Base

      DEFAULT_MATCH_TYPE = :broad
      MATCH_TYPES = { broad: 'broad', phrase: 'phrase', exact: 'exact' }
      MAX_CHARS = 80
      MAX_WORDS = 10

      # NOTE: A list of known invalid chars can be found here:
      # http://support.google.com/adwords/bin/answer.py?hl=en&answer=53539
      INVALID_CHARS = /[,!@%^*()={};~`´’<>?\|®™²»]/

      attributes :text, :match_type, :url

      def initialize(subject)
        self.match_type = DEFAULT_MATCH_TYPE
        super(subject)
      end

      def dsl_attributes
        %i(text match_type url)
      end

      def set_attributes(attrs = {})
        attrs.each do |key, value|
          public_send("#{key}=", value)
        end
      end

      def validate
        errors << "Invalid matchtype" unless valid_match_type?
        errors << "Invalid char length" unless valid_char_length?
        errors << "Too many words" unless valid_words_count?
      end

      def valid_match_type?
        MATCH_TYPES.values.include?(match_type)
      end

      def valid_char_length?
        text.size > 0 && text.size < MAX_CHARS
      end

      def valid_words_count?
        text.split.size < MAX_WORDS
      end

      def match_type=(value)
        @match_type = MATCH_TYPES.fetch(value.downcase.to_sym)
      end

      def text=(value)
        @text = Keyword.filter_invalid_chars(value)
      end

      def self.filter_invalid_chars(text)
        text.gsub(INVALID_CHARS, '').squeeze(' ').strip if text
      end

    end
  end
end
