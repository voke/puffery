module Puffery
  module Builder
    class Base

      attr_accessor :errors, :subject

      def initialize(subject)
        self.subject = subject
        self.errors = []
      end

      def validate
        raise NotImplementedError
      end

      def validate_presence_of(*attribute_names)
        attribute_names.each do |name|
          if public_send(name).to_s !~ /[^[:space:]]/
            errors << "#{name} is missing"
          end
        end
      end

      def valid?
        errors.clear
        validate
        errors.empty?
      end

      def self.attributes(*attrs)
        attr_accessor *attrs
        attribute_names.concat(attrs)
      end

      def self.attribute_names
        @attribute_names ||= []
      end

      def eval_dsl_block(&block)
        builder = DslBuilder.wrap(self)
        builder.instance_exec(&block)
        builder.finalize
      end

      def attributes
        Hash[self.class.attribute_names.map { |key| [key, send(key)] }]
      end

      def inspect
        "#<#{self.class.name} #{inspect_attributes.join(', ')}>"
      end

      def inspect_attributes
        attributes.map do |name, value|
          "#{name}: #{value.inspect}"
        end
      end

      def to_hash
        attributes
      end

      def url_helper
        @url_helper ||= UrlHelper.instance
      end

      def method_missing(method, *args, &block)
        if subject.respond_to?(method)
          subject.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to?(method_name, include_private = false)
        subject.respond_to?(method_name) || super
      end

    end
  end
end
