module Puffery
  module Model

    def puffery
      @puffery ||= Puffery::Decorator.new(self, self.class.puffery_options)
    end

    def sync_ads
      puffery.sync
    end

    module ClassMethods

      def puffery_options
        @puffery_options ||= {}
      end

      def puffery(options = {})
        @puffery_options = options
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
