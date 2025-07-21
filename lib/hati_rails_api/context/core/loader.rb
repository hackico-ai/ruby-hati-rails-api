# frozen_string_literal: true

module HatiRailsApi
  module Context
    module Core
      # Handles loading of all context components in the correct dependency order
      # Ensures proper initialization and prevents circular dependencies
      module Loader
        # Load all components in the correct order
        def self.load_all_components
          load_extensions
          load_configurations
          load_shared_components
          load_layers
          load_generators
          load_managers
        end

        private_class_method def self.load_extensions
          require_relative '../extensions/string_extensions'
        end

        private_class_method def self.load_configurations
          require_relative '../configuration/configuration'
          require_relative '../configuration/domain_configuration'
        end

        private_class_method def self.load_shared_components
          require_relative '../shared/layer_factory'
          require_relative '../shared/content_generators'
        end

        private_class_method def self.load_layers
          require_relative '../layers/standard_layer'
          require_relative '../layers/operation_layer'
        end

        private_class_method def self.load_generators
          require_relative '../generators/base_generator'
          require_relative '../generators/file_generation'
          require_relative '../generators/model_endpoint_generator'
          require_relative '../generators/layer_component_generator'
          require_relative '../generators/operation_generator'
          require_relative '../generators/domain_generator'
          require_relative '../generators/generator'
        end

        private_class_method def self.load_managers
          require_relative '../managers/rollback_manager'
        end
      end
    end
  end
end
