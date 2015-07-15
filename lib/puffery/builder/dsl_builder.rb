require 'delegate'

module Puffery
  module Builder
    class DslBuilder < SimpleDelegator

      attr_accessor :_variations

      def self.wrap(target)
        new(target).tap do |instance|
          instance._variations = Hash.new([])
        end
      end

      def _valid_setter?(name)
        __getobj__.dsl_attributes.include?(name)
      end

      def _add_variation(name, value)
        _variations[name] += [value]
      end

      def method_missing(method_name, *arguments, &block)
        if _valid_setter?(method_name)
          _add_variation(method_name, *arguments, &block)
        else
          super
        end
      end

      def finalize
        _variations.each do |key, vars|
          value = Input.extract(__getobj__, key, vars)
          __getobj__.public_send("#{key}=", value)
        end
      end

      def respond_to?(method_name, include_private = false)
        _valid_attribute?(method_name) || super
      end

    end
  end
end
