# frozen_string_literal: true

module HatiRailsApi
  module Context
    module Core
      # Comprehensive error handling module for the context system
      # Provides consistent error handling and user-friendly messages
      module ErrorHandler
        # Custom errors for the context system
        class ContextError < StandardError; end
        class ConfigurationError < ContextError; end
        class GenerationError < ContextError; end
        class RollbackError < ContextError; end

        private

        # Wraps operations with comprehensive error handling
        #
        # @param operation_name [String] Name of the operation for logging
        # @yield The block to execute with error handling
        # @return [Object] The result of the block
        # @raise [ContextError] Various context-specific errors
        def with_error_handling(operation_name = caller_locations(1, 1)[0].label)
          yield
        rescue ArgumentError => e
          handle_argument_error(e, operation_name)
        rescue StandardError => e
          handle_standard_error(e, operation_name)
        end

        # Handle argument errors with user-friendly messages
        def handle_argument_error(error, operation_name)
          puts "Invalid arguments for #{operation_name}: #{error.message}"
          puts 'Please check the documentation for correct usage'
          raise ConfigurationError, error.message
        end

        # Handle standard errors with context information
        def handle_standard_error(error, operation_name)
          puts "Error during #{operation_name}: #{error.message}"
          puts "Location: #{error.backtrace&.first}"

          case operation_name
          when /configure/
            puts 'Check your configuration syntax and required parameters'
            raise ConfigurationError, error.message
          when /generate/
            puts 'Verify your generation block and file permissions'
            raise GenerationError, error.message
          when /rollback/
            puts 'Check if the timestamp exists and files are accessible'
            raise RollbackError, error.message
          else
            raise ContextError, error.message
          end
        end

        # Log successful operations
        def log_success(operation, details = nil)
          puts "#{operation} completed successfully"
          puts "#{details}" if details
        end

        # Log warnings
        def log_warning(message)
          puts "Warning: #{message}"
        end

        # Log information
        def log_info(message)
          puts "#{message}"
        end
      end
    end
  end
end
