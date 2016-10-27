module Puffery
  module Builder
    class AdGroup < Base

      attr_accessor :keywords, :ads

      attribute :ad_group_name
      attribute :campaign_token

      def initialize(subject)
        super(Proxy.new(subject))
        self.keywords = []
        self.ads = []
      end

      def validate
        validate_presence_of(:ad_group_name, :campaign_token)
      end

      # NOTE: We extend the subject with additional methods that may be useful
      # only when building the payload. This is possible by using the Proxy
      # TODO: Warn if method is already defined on subject.__getobj__
      def helper(name, &block)
        delegation_obj = subject.__getobj__
        subject.define_singleton_method(name.to_sym) do
          instance_exec(delegation_obj, &block)
        end
      end

      def to_hash
        data = { ad_group: {} }
        data[:ad_group][:name] = ad_group_name
        data[:ad_group][:campaign_token] = campaign_token
        data[:keywords] = keywords.select(&:valid?).map(&:to_hash)
        data[:ads] = ads.select(&:valid?).map(&:to_hash)
        data
      end

      def ad(&block)
        ad = Ad.new(subject)
        ad.eval_dsl_block(&block) if block_given?
        ads.push(ad)
      end

      def xad(&block)
        ad = ExpandedAd.new(subject)
        ad.eval_dsl_block(&block) if block_given?
        ads.push(ad)
      end

      # Public: Adds keyword to AdGroup
      #
      # Examples
      #
      #  keyword('mars cruise', match_type: :broad)
      #
      #  keyword do
      #   text 'mars cruise'
      #   match_type :strict
      #  end
      #
      # returns nothing
      def keyword(text = nil, &block)
        keyword = Keyword.new(subject)
        keyword.text = text
        keyword.eval_dsl_block(&block) if block_given?
        keywords.push(keyword)
      end

    end
  end
end
