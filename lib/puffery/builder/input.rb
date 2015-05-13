module Puffery
  module Builder
    class Input

      # A list of the limits can be found here:
      # https://code.google.com/apis/adwords/docs/appendix/limits.html
      # Display URLs will be shortened if greater than 35 characters long
      # TODO : Destination URL length and Display URL length uses bytes...
      FIELD_OPTIONS = {
        headline: { length: 25, validate: true },
        description1: { length: 35, validate: true },
        description2: { length: 35, validate: true },
        display_url: { bytesize: 255, validate: false },
        url: { bytesize: 1024, validate: false }
      }

      attr_accessor :text, :subject

      def initialize(subject, text, options = {})
        assert_valid_keys(options, :length, :bytesize, :validate)
        @text = text.is_a?(String) ? InterpolatedString.new(text, subject).to_s : text
        @max_length = options[:length]
        @max_bytesize = options[:bytesize]
        @validate = options[:validate] || false
      end

      def assert_valid_keys(hash, *valid_keys)
        valid_keys.flatten!
        hash.each_key do |k|
          unless valid_keys.include?(k)
            raise ArgumentError.new("Unknown key: #{k.inspect}.")
          end
        end
      end

      def to_s
        text
      end

      def valid?
        valid_length? && valid_bytesize? && valid_words?
      end

      def valid_words?
        # TODO: Check against a blacklist to see if the word is valid
        @validate ? true : true
      end

      def valid_bytesize?
        @max_bytesize ? (sanitized.bytesize <= @max_bytesize) : true
      end

      def valid_length?
        @max_length ? (sanitized.length <= @max_length) : true
      end

      # Public: Text without value track parameters.
      # Remove AdWords keyword insertion {keyword} snippet to get proper length
      # i.e "Compare {KeyWord:Our Brand Names Today}" becomes "Compare Our Brand Names Today"
      # More info: http://support.google.com/adwords/bin/answer.py?hl=en-AU&answer=74996
      #
      # Returns sanitized String.
      def sanitized
        text.gsub(/\{keyword:(.+)\}/i, "\\1")
      end

      def self.extract(subject, field, variations)
        options = FIELD_OPTIONS.fetch(field.to_sym, {})
        if input = Input.first_valid(subject, *variations, options)
          input.to_s
        end
      end

      def self.first_valid(subject, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        inputs = args.map { |string| new(subject, string, options) }
        inputs.find(&:valid?)
      end

    end
  end
end
