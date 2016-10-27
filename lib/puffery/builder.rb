require 'puffery/builder/attribute'
require 'puffery/builder/attribute_set'
require 'puffery/builder/proxy'
require 'puffery/builder/base'
require 'puffery/builder/ad_group'
require 'puffery/builder/ad'
require 'puffery/builder/keyword'
require 'puffery/builder/interpolated_string'
require 'puffery/builder/dsl_builder'
require 'puffery/builder/payload'

module Puffery
  module Builder

    def self.build(target, namespace)
      ad_group = AdGroup.new(target)
      ad_group.eval_dsl_block(&namespace.block)
      Payload.new(ad_group.to_hash)
    end

  end
end
