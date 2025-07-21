# frozen_string_literal: true

require_relative '../shared/content_generators'

module HatiRailsApi
  module Context
    # Concern for model and endpoint generation
    # Follows Single Responsibility Principle - handles only model/endpoint generation
    module ModelEndpointGenerator
      include ContentGenerators

      DEFAULT_MODEL = {
        path: 'app/models',
        base: 'ApplicationRecord'
      }.freeze

      DEFAULT_ENDPOINT = {
        path: 'app/controllers/api',
        base: 'ApplicationController'
      }.freeze

      def generate_domain_model
        options = @domain_model[:options] || {}

        path = @config&.model_config&.dig(:path)
        base_path = options[:path] || path || DEFAULT_MODEL[:path]

        base = @config&.model_config&.dig(:base)
        base_class = base || DEFAULT_MODEL[:base]

        file_path = File.join(base_path, "#{@name}.rb")
        content = generate_model_content(name: @name, base_class: base_class)

        generate_file?(file_path, content)
      end

      def generate_domain_endpoint
        options = @domain_endpoint[:options] || {}

        path = @config&.endpoint_config&.dig(:path)
        base_path = options[:path] || path || DEFAULT_ENDPOINT[:path]

        base = @config&.endpoint_config&.dig(:base)
        base_class = base || DEFAULT_ENDPOINT[:base]

        file_path = File.join(base_path, "#{@name}_controller.rb")
        content = generate_endpoint_content(base_class)

        generate_file?(file_path, content)
      end

      def generate_endpoint_content(base_class)
        # Get operation components to generate actions
        operation_components = get_operation_components
        actions_code = generate_controller_actions(operation_components)

        generate_controller_content(
          name: @name,
          base_class: base_class,
          actions_code: actions_code
        )
      end

      def get_operation_components
        # If explicit components are provided in endpoint declaration, use those
        return @domain_endpoint[:explicit_components] if @domain_endpoint&.dig(:explicit_components)

        # Otherwise, use operation layer components
        operation_layer = @layers[:operation]
        return [] unless operation_layer

        operation_layer.components.reject { |comp| comp == :domain }
      end

      def generate_controller_actions(components)
        return '  # TODO: Add controller actions here' if components.empty?

        actions = components.map do |component|
          action_name = component.to_s
          operation_class = "#{action_name.camelize}Operation"

          generate_custom_action(action_name, operation_class)
        end

        actions.join("\n\n")
      end

      def generate_custom_action(action_name, operation_class)
        <<~RUBY.chomp
          def #{action_name}
            run_and_render #{operation_class}
          end
        RUBY
      end
    end
  end
end
