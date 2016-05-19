require 'puffery/version'
require 'puffery/configuration'
require 'puffery/client'
require 'puffery/namespace'
require 'puffery/builder'
require 'puffery/controller'
require 'puffery/model'
require 'puffery/core_ext/string'
require 'puffery/engine' if defined?(Rails)

module Puffery

  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration
  end

  def debug?
    !!configuration.debug
  end

  def load_files
    files_in_load_path.each { |file| require(file) }
  end

  def files_in_load_path
    configuration.load_paths.flatten.compact.uniq.map do |path|
      Dir["#{path}/**/*.rb"]
    end.flatten
  end

  def register(name, &block)
    Namespace.add(name, &block)
  end

  def url_helper
    @url_helper ||= begin
      raise 'Rails must be defined to use URL helpers' unless defined?(Rails)
      Rails.application.routes.url_helpers
    end
  end

  def build_payload(resource, ns_name = nil)
    ns_name ||= resource.namespace
    namespace = Namespace.find(ns_name)
    Puffery::Builder.build(resource, namespace)
  end

end
