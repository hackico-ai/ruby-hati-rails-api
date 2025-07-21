# frozen_string_literal: true

# Core components
require_relative 'core/loader'
require_relative 'core/public_api'
require_relative 'core/error_handler'
require_relative 'core/migration'

module HatiRailsApi
  module Context
    # Core module containing all essential components
    # Provides a clean separation of concerns and proper error handling
    module Core
      # Initialize the core system
      Loader.load_all_components
    end
  end
end
