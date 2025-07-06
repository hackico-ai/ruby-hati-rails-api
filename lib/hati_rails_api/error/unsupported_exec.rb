# frozen_string_literal: true

module HatiRailsApi
  module Error
    class UnsupportedExec < StandardError
      def initialize(op)
        super("Unsupported operation type: #{op.class}. Expected HatiCommand::Result or HatiOperation::Base")
      end
    end
  end
end
