# frozen_string_literal: true

module HatiRailsApi
  module Context
    # Shared content generation methods
    # Eliminates duplicate content generation across generators
    module ContentGenerators
      TIMESTAMP_PATTERN = '%Y%m%d%H%M%S'

      private

      def generate_class_content(class_name:, base_class:, timestamp: nil, &_block)
        timestamp ||= Time.now.strftime(TIMESTAMP_PATTERN)

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}

          class #{class_name} < #{base_class}
            #{block_given? ? yield : '# TODO: Add implementation here'}
          end
        RUBY
      end

      def generate_model_content(name:, base_class:, timestamp: nil)
        msg = "# TODO: Add #{name} model logic here"

        generate_class_content(
          class_name: name,
          base_class: base_class,
          timestamp: timestamp
        ) do
          msg
        end
      end

      def generate_controller_content(name:, base_class:, actions_code: nil, timestamp: nil)
        class_name = "#{name.to_s.camelize}Controller"
        timestamp ||= Time.now.strftime(TIMESTAMP_PATTERN)

        # Ensure actions are properly indented
        indented_actions = if actions_code && actions_code.strip != '# TODO: Add controller logic here'
                             actions_code.split("\n").map { |line| "  #{line}" }.join("\n")
                           else
                             '  # TODO: Add controller logic here'
                           end

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}

          class #{class_name} < #{base_class}
            include HatiRailsApi::ResponseHandler

          #{indented_actions}
          end
        RUBY
      end

      def generate_operation_content(class_name:, base_class:, action:, step_content: nil, timestamp: nil)
        timestamp ||= Time.now.strftime(TIMESTAMP_PATTERN)

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}
          class #{class_name} < #{base_class}
            # Operation configuration
            #{generate_operation_macros(action)}

            def call(params:)
              #{step_content || generate_default_steps_for_action(action)}
            end

            private

            #{generate_private_steps(action)}
          end
        RUBY
      end

      def generate_step_based_operation_content(
        class_name:, base_class:, step_declarations:, step_calls:, timestamp: nil
      )
        timestamp ||= Time.now.strftime(TIMESTAMP_PATTERN)

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{timestamp}
          class #{class_name} < #{base_class}
          #{step_declarations}

            def call(params:)
          #{step_calls}

              Success(rez)
            end
          end
        RUBY
      end

      def generate_operation_macros(_action)
        '# Add operation configuration macros here'
      end

      def generate_default_steps_for_action(action)
        <<~RUBY.strip
          # TODO: Implement #{action} business logic
          # Add your step-based implementation here

          Success(params)
        RUBY
      end

      def generate_private_steps(_action)
        <<~RUBY.strip
          # TODO: Add your private step methods here
          # Example:
          # def validate_params(params)
          #   Success(params)
          # end
        RUBY
      end
    end
  end
end
