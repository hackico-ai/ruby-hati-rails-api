# frozen_string_literal: true

module HatiRailsApi
  module Context
    # Base class for context migrations
    # Provides Rails-like migration interface for context generation
    class Migration
      def initialize
        @generator = nil
      end

      # Domain definition method
      #
      # @param name [Symbol] Domain name
      # @param block [Proc] Domain configuration block
      def domain(name, &block)
        ensure_generator
        @generator.domain(name, &block)
      end

      # Model generation method
      #
      # @param names [Array, Symbol] Model names to generate
      def model(names)
        ensure_generator
        Array(names).each { |name| @generator.model(name) }
      end

      # Endpoint generation method
      #
      # @param names [Array, Symbol] Endpoint names to generate
      def endpoint(names)
        ensure_generator
        Array(names).each { |name| @generator.endpoint(name) }
      end

      # Execute the migration - called automatically after change
      def execute
        return unless @generator

        @generator.execute
      end

      # Method to be overridden by migration classes
      def change
        raise NotImplementedError, 'Migration classes must implement the change method'
      end

      # Run the migration (calls change then execute)
      def run
        change
        execute
      end

      private

      def ensure_generator
        return if @generator

        # Get the global configuration
        config = HatiRailsApi::Context.instance_variable_get(:@global_config)

        # Create a new generator instance with force option
        @generator = HatiRailsApi::Context::Generator.new(config, force: true)
      end
    end
  end
end
