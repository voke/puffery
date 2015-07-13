module Puffery
  module Builder
    class Ad < Base

      attributes :headline, :description1, :description2, :display_url, :url

      def validate
        validate_presence_of(:headline, :description1, :description2,
          :display_url, :url)
      end

    end
  end
end
