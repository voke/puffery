require 'delegate'

module Puffery
  module Builder
    class DslBuilder < SimpleDelegator

      attr_accessor :valid_attributes, :setter
      DELEGATE_WRITE_METHOD = :write_attribute

      def self.wrap(target, valid_attributes = [], setter: DELEGATE_WRITE_METHOD)
        new(target).tap do |instance|
          instance.valid_attributes = valid_attributes.map(&:to_sym)
          instance.setter = setter
        end
      end

      def _valid_attribute?(name)
        valid_attributes.include?(name.to_sym)
      end

      def _set_attribute(name, value)
        __getobj__.public_send(setter, name, value)
      end

      def method_missing(method_name, *arguments, &block)
        if _valid_attribute?(method_name)
          _set_attribute(method_name, *arguments, &block)
        else
          super
        end
      end

      def respond_to?(method_name, include_private = false)
        _valid_attribute?(method_name) || super
      end

    end
  end
end
