# frozen_string_literal: true

require_relative 'context/core'

module HatiRailsApi
  # Main Context module providing the public API for code generation
  #
  # This module serves as the entry point for all context-related operations
  # including configuration, generation, and rollback functionality.
  #
  # @example Basic usage
  #   HatiRailsApi::Context.configure do |config|
  #     config.base_path 'app/contexts'
  #   end
  #
  #   HatiRailsApi::Context.generate do |ctx|
  #     ctx.domain :user do |domain|
  #       domain.operation { |op| op.component [:create, :update] }
  #       domain.endpoint enabled: true
  #     end
  #   end
  #
  # @example Rollback
  #   HatiRailsApi::Context.rollback('20240101120000')
  #   HatiRailsApi::Context.rollback  # rolls back last generation
  #
  module Context
    extend Core::PublicAPI
  end
end
