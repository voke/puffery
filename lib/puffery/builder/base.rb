module Puffery
  module Builder
    class Base

      attr_accessor :errors, :subject, :attributes

      def initialize(subject)
        self.subject = subject
        self.errors = []
        self.attributes = {}
      end

      def self.attributes
        @attributes ||= AttributeSet.new
      end

      def self.attribute(name, options = {})

        self.attributes.add(name, options)

        define_method("#{name}") do
          read_attribute(name)
        end

        define_method("#{name}=") do |value|
          write_attribute(name, value)
	      end

      end

      def read_attribute(name)
        self.attributes[name.to_sym]
      end

      def write_attribute(name, value)
        if attributes[name].nil?
          self.attributes[name] = self.class.attributes.valid_value(name, value)
        end
      end

      def write_bulk_attributes(attrs = {})
        attrs.each do |key, value|
          write_attribute(key, value)
        end
      end

      def self.attribute_names
        attributes.keys
      end

      def eval_dsl_block(&block)
        builder = DslBuilder.wrap(self, attributes)
        builder.instance_exec(&block)
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
        #attributes
        raise "fakk this shit"
      end

      def url_helper
        Puffery.url_helper
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
