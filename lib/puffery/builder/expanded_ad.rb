module Puffery
  module Builder
    class ExpandedAd < Base

      # A list of the limits can be found here:
      # https://developers.google.com/adwords/api/docs/guides/expanded-text-ads

      attribute :headline1, max_chars: 30
      attribute :headline2, max_chars: 30

      attribute :description, max_chars: 80

      attribute :path1
      attribute :path2

      attribute :final_url, max_bytesize: 1024

    end
  end
end
