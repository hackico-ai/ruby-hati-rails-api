# frozen_string_literal: true

require_relative '../layers/operation_layer'
require_relative '../layers/standard_layer'

module HatiRailsApi
  module Context
    # Shared layer factory methods
    # Eliminates duplicate layer creation logic
    module LayerFactory
      protected

      def create_operation_layer(&block)
        layer = OperationLayer.new
        layer.instance_eval(&block) if block_given?
        layer
      end

      def create_standard_layer(layer_name, &block)
        layer = StandardLayer.new(layer_name.to_sym)
        if block_given?
          layer.instance_eval(&block)
        else
          # Set default component to :domain for plain layer declarations
          layer.component(:domain)
        end
        layer
      end

      def create_dynamic_layer(method_name, *args, &block)
        # Always create a layer for method calls
        # This handles cases like: domain.validation, domain.query, domain.service
        create_standard_layer(method_name, &block)
      end
    end
  end
end
