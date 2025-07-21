# frozen_string_literal: true

require_relative '../shared/content_generators'

module HatiRailsApi
  module Context
    # Concern for operation generation
    # Follows Single Responsibility Principle - handles only operation generation
    module OperationGenerator
      include ContentGenerators

      TIMESTAMP_FORMAT = '%Y%m%d%H%M%S'

      def generate_component_operation_content(component:, class_name:, layer_config:)
        base_class = resolve_base_class(layer_config)
        action = extract_action_from_component(component)
        timestamp = Time.now.strftime(TIMESTAMP_FORMAT)

        # Check if we should generate step-based operations
        if should_use_steps?(layer_config)
          generate_step_based_operation_content(
            class_name: class_name,
            base_class: base_class,
            action: action,
            layer_config: layer_config,
            timestamp: timestamp
          )
        else
          generate_simple_operation_content(
            class_name: class_name,
            base_class: base_class,
            action: action,
            timestamp: timestamp
          )
        end
      end

      def generate_step_based_operation(class_name:, base_class:, action:, steps:)
        step_declarations = generate_step_declarations(action, steps)
        step_calls = generate_step_calls(steps)

        generate_step_based_operation_content(
          class_name: class_name,
          base_class: base_class,
          step_declarations: step_declarations,
          step_calls: step_calls
        )
      end

      def generate_standard_operation(class_name:, base_class:, action:, base_requirement:)
        steps_content = generate_default_steps_for_action(action)
        timestamp = Time.now.strftime(TIMESTAMP_FORMAT)

        if base_requirement.blank?
          generate_operation_content(
            class_name: class_name,
            base_class: base_class,
            action: action,
            steps_content: steps_content
          )
          return
        end

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}

          #{base_requirement}class #{class_name} < #{base_class}
            # Operation configuration
            #{generate_operation_macros(action)}

            def call(params:)
              #{steps_content}
            end

            private

            #{generate_private_steps(action)}
          end
        RUBY
      end

      private

      def should_use_steps?(layer_config)
        # If operation layer has explicit steps, use those
        return true if layer_config.respond_to?(:steps) && layer_config.steps.any?

        # If step options include granular: true, use steps from other layers
        return true if layer_config.respond_to?(:granular_steps?) && layer_config.granular_steps?

        # If domain has multiple layers besides operation, use steps
        other_layers = @layers.keys.reject { |name| name == :operation }
        other_layers.any?
      end

      def generate_step_based_operation_content(class_name:, base_class:, action:, layer_config:, timestamp:)
        steps = determine_steps_for_operation(layer_config)
        step_declarations = generate_step_declarations(action, steps)

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}

          class #{class_name} < #{base_class}
          #{step_declarations}

            def call(params:)
              Success(params)
            end
          end
        RUBY
      end

      def generate_simple_operation_content(class_name:, base_class:, action:, timestamp:)
        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}

          class #{class_name} < #{base_class}
            def call(params:)
              # TODO: Implement #{action} business logic
              # Add your implementation here

              Success(params)
            end

            private

            # TODO: Add your private methods here
            # Example:
            # def validate_params(params)
            #   # validation logic
            # end
          end
        RUBY
      end

      def determine_steps_for_operation(layer_config)
        # If operation has explicit steps configured, use those
        return layer_config.steps if layer_config.respond_to?(:steps) && layer_config.steps.any?

        # If granular steps enabled, use other domain layers as steps
        if layer_config.respond_to?(:granular_steps?) && layer_config.granular_steps?
          return @layers.keys.reject { |name| name == :operation }
        end

        # Otherwise, use domain layers (excluding operation itself)
        @layers.keys.reject { |name| name == :operation }
      end

      def generate_step_declarations(action, steps)
        steps_arr = steps.map do |step_name|
          service_class = "#{action.camelize}#{step_name.to_s.camelize}"
          "  step #{step_name}: \"#{service_class}\""
        end

        steps_arr.join("\n")
      end

      def generate_step_calls(steps)
        step_calls = steps.map do |step_name|
          "      rez = #{step_name}.call(rez)"
        end

        (['      rez = params'] + step_calls).join("\n")
      end

      def resolve_base_class(layer_config)
        if layer_config.base_class
          layer_config.base_class.split('/').last.camelize
        else
          'HatiOperation::Base'
        end
      end

      def extract_action_from_component(component)
        component.is_a?(Hash) ? component.keys.first.to_s : component.to_s
      end
    end
  end
end
