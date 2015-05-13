module Puffery
  class Configuration

    attr_accessor :api_url, :api_key, :load_paths

    def initialize
      if defined?(Rails)
        self.load_paths ||= Array(File.expand_path('app/ad_groups', Rails.root))
      end
    end

  end
end
