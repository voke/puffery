module Puffery
  module Builder
    class Attribute

      attr_accessor :value, :subject, :max_bytesize, :max_chars, :max_words,
        :inclusion

      def initialize(value, subject, max_words: nil, max_bytesize: nil,
        max_chars: nil, inclusion: [])
        self.value = value.to_s
        self.subject = subject
        self.max_chars = max_chars
        self.max_bytesize = max_bytesize
        self.max_words = max_words
        self.inclusion = inclusion
      end

      def valid?
        valid_length? && valid_bytesize? && valid_words?
      end

      def to_s
        value
      end

      def valid_words?
        max_words ? (sanitized.split.size <= max_words) : true
      end

      def valid_bytesize?
        max_bytesize ? (sanitized.bytesize <= max_bytesize) : true
      end

      def valid_length?
        max_chars ? (sanitized.size <= max_chars) : true
      end

      # Public: Text without value track parameters.
      # Remove AdWords keyword insertion {keyword} snippet to get proper length
      # i.e "Compare {KeyWord:Our Brand Names Today}" becomes "Compare Our Brand Names Today"
      # More info: http://support.google.com/adwords/bin/answer.py?hl=en-AU&answer=74996
      #
      # Returns sanitized String.
      def sanitized
        value.gsub(/\{keyword:(.+)\}/i, "\\1")
      end

    end
  end
end
