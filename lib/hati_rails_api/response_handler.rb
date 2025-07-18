# frozen_string_literal: true

# require 'hati_operation'
require 'pry'

# TODO:
## success macros:
# - 200
# - 201
# - 204
# - 206
# - 207
## on_failure & on_success result mappers

module HatiRailsApi
  module ResponseHandler
    # WIP: think about global configs
    HatiJsonapiError::Config.configure do |config|
      config.load_errors!
      config.use_unexpected = HatiJsonapiError::InternalServerError
      # WIP: map or preload from rails errors to statuses ???
      # config.map_errors = {
      #   ActiveRecord::RecordNotFound => :not_found,
      #   ActiveRecord::RecordInvalid => :unprocessable_entity
      # }
    end

    def self.included(base)
      base.include HatiJsonapiError::Helpers
    end

    private

    # WIP:
    def unsafe_params
      params.respond_to?(:permit) ? params.permit.to_unsafe_h : params
    end

    # specific for api-errror lib !!!!
    # WIP: debug access ??
    def run_and_render(operation, &block)
      result = run_operation(operation, &block)
      result_value = result.value
      status = result_value.try(:status)

      if result.success?
        render_success(result_value, status: status)
      else
        # WIP:
        # render_error(result.error || result.value) ????
        # setup error object with meta data ???
        render_error(result.error)
      end
    end

    def run_operation(operation, &block)
      return operation if operation.is_a?(HatiCommand::Result)
      raise Errors::UnsupportedOperationError, operation unless operation < HatiOperation::Base

      if block_given?
        operation.call(params: unsafe_params, &block)
      else
        operation.call(params: unsafe_params)
      end
    end

    def render_success(result_value, status: 200)
      render json: { data: result_value }, status: status
    end
  end
end
