# frozen_string_literal: true

require_relative 'file_generation'

module HatiRailsApi
  module Context
    # Base generator class providing common functionality
    # Follows DRY principle - shared functionality for all generators
    class BaseGenerator
      include FileGeneration

      TIMESTAMP_PATTERN = '%Y%m%d%H%M%S'

      attr_reader :config, :generated_files, :timestamp, :force

      def initialize(config = nil, force: false)
        @config = config
        @generated_files = []
        @timestamp = Time.now.strftime(TIMESTAMP_PATTERN)
        @force = force
        @override_all = nil
      end

      private

      def override_all_state(value = nil)
        return @override_all if value.nil?

        @override_all = value
      end
    end
  end
end
