# frozen_string_literal: true

require_relative 'error_handler'

module HatiRailsApi
  module Context
    module Core
      # Public API module providing all external-facing methods
      # Includes comprehensive error handling and validation
      module PublicAPI
        include ErrorHandler

        # Global configuration storage
        attr_accessor :global_config

        # Configure the context system with global settings
        #
        # @param block [Proc] Configuration block
        # @return [Configuration] The configuration object
        # @raise [ArgumentError] If no block is provided
        #
        # @example
        #   Context.configure do |config|
        #     config.base_path 'app/contexts'
        #     config.model path: 'app/models', base: 'ApplicationRecord'
        #   end
        def configure(&block)
          raise ArgumentError, 'Configuration block is required' unless block_given?

          with_error_handling do
            @global_config = Configuration.new
            @global_config.instance_eval(&block)
            @global_config
          end
        end

        # Generate files based on configuration
        #
        # @param force [Boolean] Force overwrite existing files
        # @param block [Proc] Generation block
        # @return [Boolean] True if generation was successful
        # @raise [ArgumentError] If no block is provided
        #
        # @example
        #   Context.generate do |ctx|
        #     ctx.domain :user do |domain|
        #       domain.operation { |op| op.component [:create, :update] }
        #       domain.endpoint enabled: true
        #     end
        #   end
        def generate(force: false, &block)
          raise ArgumentError, 'Generation block is required' unless block_given?

          with_error_handling do
            generator = Generator.new(@global_config, force: force)
            generator.instance_eval(&block)
            generator.execute
            true
          end
        end

        # Rollback generated files by timestamp or last generation
        #
        # @param timestamp [String, nil] Specific timestamp to rollback, or nil for last
        # @return [Boolean] True if rollback was successful
        #
        # @example
        #   Context.rollback('20240101120000')  # specific timestamp
        #   Context.rollback                    # last generation
        def rollback(timestamp = nil)
          with_error_handling do
            rollback_manager = RollbackManager.new

            if timestamp
              rollback_manager.rollback_by_timestamp?(timestamp)
            else
              rollback_manager.rollback_last?
            end
          end
        end

        # List all tracked generations with detailed information
        #
        # @return [Boolean] True if listing was successful
        #
        # @example
        #   Context.list_generations
        def list_generations
          with_error_handling do
            RollbackManager.new.list_generations
            true
          end
        end

        # Reset the global configuration
        #
        # @return [Boolean] True if reset was successful
        def reset_configuration
          with_error_handling do
            @global_config = nil
            true
          end
        end

        # Check if the system is configured
        #
        # @return [Boolean] True if configured
        def configured?
          !@global_config.nil?
        end
      end
    end
  end
end
