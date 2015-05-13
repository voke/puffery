module Puffery
  module Builder
    class InterpolatedString

      def initialize(text, subject)
        @text = text
        @subject = subject
      end

      def to_s
        compile
      end

      # Matches placeholders like "%{foo}"
      def compile
        @text.gsub(/%\{(\w*)\}/) { |match| @subject.public_send(match[2..-2]) }
      end

    end
  end
end
