require 'delegate'

module Puffery
  module Builder
    class Proxy < SimpleDelegator

      # We wrap the traget class so we can add temporary
      # helper methods to this class without influence the
      # target object.

      # NOTE: Must implement eql? to get url_for to work
      # https://github.com/rails/journey/issues/29
      def eql?(other)
        __getobj__ == other.__getobj__
      end

    end
  end
end
