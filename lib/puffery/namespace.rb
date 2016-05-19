module Puffery
  class Namespace

    DuplicateError = Class.new(StandardError)
    MissingError = Class.new(StandardError)

    attr_accessor :name, :block
    @namespaces = []

    def initialize(name, &block)
      self.name = name
      self.block = block
    end

    def name=(value)
      @name = Namespace.normalize(value)
    end

    def self.normalize(name)
      name.to_s.downcase.to_sym
    end

    def self.all
      @namespaces
    end

    def self.exists?(namespace)
      @namespaces.map(&:name).include?(namespace.name)
    end

    def self.add(name, &block)
      namespace = Namespace.new(name, &block)
      if exists?(namespace)
        error_msg = "Warning from puffery: Namespace named '#{name}' already exists."
        warn error_msg
      else
        @namespaces.push(namespace)
      end
    end

    def self.find(name)
      normalized_name = Namespace.normalize(name)
      @namespaces.find do |ns|
        ns.name == normalized_name
      end || raise(MissingError,
        "No namespace found for '#{normalized_name}'.")
    end

  end
end
