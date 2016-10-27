module Puffery
  module Builder
    class AttributeSet

      def initialize
        @items = {}
      end

      def add(name, options)
        @items[name] = options
      end

      def keys
        @items.keys
      end

      def valid?(attr_name)
        @items.keys.include?(attr_name)
      end

      def valid_value(name, value)
        opts = @items.fetch(name)
        attr = Attribute.new(value, nil, opts)
        attr.valid? ? attr.value : nil
      end

    end
  end
end
