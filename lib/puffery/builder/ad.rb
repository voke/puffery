module Puffery
  module Builder
    class Ad < Base

      # A list of the limits can be found here:
      # https://code.google.com/apis/adwords/docs/appendix/limits.html
      # Display URLs will be shortened if greater than 35 characters long
      # TODO : Destination URL length and Display URL length uses bytes...

      attribute :headline, max_chars: 25
      attribute :description1, max_chars: 35
      attribute :description2, max_chars: 35

      attribute :display_url, max_bytesize: 255
      attribute :url, max_bytesize: 1024

      def validate
        validate_presence_of(:headline, :description1, :description2,
          :display_url, :url)
      end

    end
  end
end
