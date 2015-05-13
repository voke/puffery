module Puffery
  module Builder
    class Ad < Base

      attributes :headline, :description1, :description2, :display_url, :final_urls

      def validate
        validate_presence_of(:headline, :description1, :description2,
          :display_url, :final_urls)
      end

    end
  end
end
