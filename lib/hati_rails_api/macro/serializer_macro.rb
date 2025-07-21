# frozen_string_literal: true

module HatiRailsApi
  module Macro
    class SerializerMacro
      include HatiCommand::Cmd

      def call(serializer, status: 200)
        Success(serializer.call(status: status))
      end
    end
  end
end
