# frozen_string_literal: true

require 'hati_command'
require 'hati_operation'
require 'pry'

module HatiRailsApi
  module ResponseHandler
    # API operation helpers

    DEF_ERR = :internal_server_error
    DEF_ERR_MSG = 'An unexpected error occurred'
    DEF_SCS = :ok
    DEF_SCS_MSG = 'Operation completed successfully'

    private

    def run_and_render(operation, &block)
      result = execute_operation(operation, &block)
      result_value = result.value

      return render_success(result_value) if result.success?

      status = result_value.try(:status) || DEF_ERR
      render_error(result_value, status: status)
    rescue StandardError => e
      handle_unexpected_error(e)
    end

    def execute_operation(op, &block)
      return op if op.is_a?(HatiCommand::Result)

      # TODO: or check if it has rescpective obj API
      raise Error::UnsupportedExec, op unless op < HatiOperation::Base

      block_given? ? op.call(params: unsafe_params, &block) : op.call(params: unsafe_params)
    end

    # WIP:
    def unsafe_params
      params.respond_to?(:permit) ? params.permit.to_unsafe_h : params
    end

    # TODO: Error handler class
    def handle_unexpected_error(error)
      Rails.logger.error "Unexpected error in ResponseHandler: #{error.message}"
      Rails.logger.error error.backtrace.join("\n")

      render_error(
        {
          message: 'An unexpected error occurred',
          details: error.message
        },
        status: :internal_server_error
      )
    end

    def render_error(error, status: :unprocessable_entity)
      error_response = normalize_error_response(error)

      render json: { error: error_response }, status: status
    end

    def render_success(data)
      render json: { data: data }, status: :ok
    end

    def normalize_error_response(error)
      case error
      when String
        { message: error }
      when Hash
        error
      when Array
        { messages: error }
      else
        { message: error.to_s }
      end
    end
  end
end
