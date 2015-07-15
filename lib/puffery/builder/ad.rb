module Puffery
  module Builder
    class Ad < Base

      ATTRIBUTES = %i(headline description1 description2 display_url url)

      attributes *ATTRIBUTES

      def validate
        validate_presence_of(*ATTRIBUTES)
      end

      def dsl_attributes
        ATTRIBUTES
      end

    end
  end
end
