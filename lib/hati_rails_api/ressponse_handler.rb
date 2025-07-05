module HatiRailsApi
  module ResponseHandler
    # API operation helpers
    def run_and_render(operation, **options, &block)
      result = execute_operation(operation, **options, &block)

      if result.success?
        render_success(result.value)
      else
        render_error(result.value, status: result.status || :unprocessable_entity)
      end
    rescue StandardError => e
      handle_unexpected_error(e)
    end

    private

    def execute_operation(operation, **options, &block)
      case operation
      when HatiCommand::Result
        operation
      when HatiOperation::Base
        if block_given?
          operation.call(params: merged_params(**options), &block)
        else
          operation.call(params: merged_params(**options))
        end
      else
        raise ArgumentError, "Unsupported operation type: #{operation.class}. " \
                           'Expected HatiCommand::Result or HatiOperation::Base'
      end
    end

    def merged_params(**options)
      params.respond_to?(:permit) ? params.to_unsafe_h.merge(options) : params.merge(options)
    end

    def handle_unexpected_error(error)
      Rails.logger.error "Unexpected error in ResponseHandler: #{error.message}"
      Rails.logger.error error.backtrace.join("\n")

      render_error(
        { message: 'An unexpected error occurred', details: error.message },
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
