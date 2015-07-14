require 'puffery/version'
require 'puffery/configuration'
require 'puffery/client'
require 'puffery/namespace'
require 'puffery/engine' if defined?(Rails)
require 'puffery/builder'
require 'puffery/model'

module Puffery

  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration
  end

  def load_files
    files_in_load_path.each { |file| require_dependency(file) }
  end

  def files_in_load_path
    configuration.load_paths.flatten.compact.uniq.map do |path|
      Dir["#{path}/**/*.rb"]
    end.flatten
  end

  def register(name, &block)
    Namespace.add(name, &block)
  end

  def build_payload(resource, ns_name = nil)
    ns_name ||= resource.namespace
    namespace = Namespace.find(ns_name)
    Puffery::Builder.build(resource, namespace)
  end

end
