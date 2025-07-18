# frozen_string_literal: true

module HatiRailsApi
  module Errors
    class UnsupportedOperationError < StandardError
      def initialize(message = 'Unsupported operation')
        super
      end
    end
  end
end
