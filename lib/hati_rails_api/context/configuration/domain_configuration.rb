# frozen_string_literal: true

require_relative '../shared/layer_factory'

module HatiRailsApi
  module Context
    # Domain-specific configuration class
    # Follows Single Responsibility Principle - handles domain layer configuration
    class DomainConfiguration
      include LayerFactory

      DEFAULT_DOMAIN_STATE = { enabled: false }.freeze

      attr_reader :layers

      def initialize
        @layers = {}
      end

      def operation(&block)
        @layers[:operation] = create_operation_layer(&block)
      end

      def layer(layer_name, &block)
        @layers[layer_name.to_sym] = create_standard_layer(layer_name, &block)
      end

      def endpoint(enabled: true, **options)
        @domain_endpoint = create_endpoint_state(enabled, options)
      end

      def method_missing(method_name, ...)
        result = create_dynamic_layer(method_name, ...)
        return super unless result

        @layers[method_name.to_sym] = result
      end

      def respond_to_missing?(_method_name, _include_private = false)
        true
      end

      private

      def create_endpoint_state(enabled, options)
        case enabled
        when false then DEFAULT_DOMAIN_STATE
        when true  then { enabled: true, options: options, explicit_components: nil }
        when Array then { enabled: true, options: options, explicit_components: enabled }
        when Hash  then { enabled: true, options: enabled, explicit_components: nil }
        end
      end
    end
  end
end
