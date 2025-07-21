# frozen_string_literal: true

require_relative 'domain_configuration'

module HatiRailsApi
  module Context
    # Main configuration class for the context system
    # Follows Single Responsibility Principle - handles global configuration
    class Configuration
      attr_accessor :model_config, :endpoint_config, :domain_config

      def initialize
        @base_path = 'app/contexts'
        @model_config = { path: 'app/models', base: 'ApplicationRecord' }
        @endpoint_config = { path: 'app/controllers/api', base: 'ApplicationController' }
        @domain_config = DomainConfiguration.new
      end

      def base_path(path = nil)
        return @base_path unless path

        @base_path = path
      end

      def model(path: nil, base: nil)
        @model_config.merge!(path: path) if path
        @model_config.merge!(base: base) if base
        @model_config
      end

      def endpoint(enabled = true, **options)
        return @endpoint_config unless enabled || !options.empty?

        case enabled
        when false
          @endpoint_config = { enabled: false }
        when Hash
          @endpoint_config.merge!(enabled)
        else
          @endpoint_config.merge!(options)
        end
      end

      def domain(&block)
        @domain_config.instance_eval(&block) if block_given?
        @domain_config
      end
    end
  end
end
