# frozen_string_literal: true

require_relative 'standard_layer'

module HatiRailsApi
  module Context
    # Operation layer configuration class
    # Extends StandardLayer for operation-specific functionality
    class OperationLayer < StandardLayer
      attr_reader :step_options

      def initialize
        super(:operation)
        @base_class = 'hati_operation/base'
        @step_options = {}
      end

      def step(*step_names, **options)
        if step_names.empty? && options.any?
          # Handle: operation.step true, granular: true
          @step_options.merge!(options)
        elsif step_names.any?
          # Handle: operation.step :validate, :encrypt, :store
          @steps = step_names.flatten
          @step_options.merge!(options) if options.any?
        end
      end

      def steps
        @steps || []
      end

      def granular_steps?
        @step_options[:granular] == true
      end

      def dup
        new_layer = super
        new_layer.instance_variable_set(:@steps, @steps&.dup)
        new_layer.instance_variable_set(:@step_options, @step_options.dup)
        new_layer
      end
    end
  end
end
