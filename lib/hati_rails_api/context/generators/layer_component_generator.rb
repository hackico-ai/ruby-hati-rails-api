# frozen_string_literal: true

module HatiRailsApi
  module Context
    # Concern for layer and component generation
    # Follows Single Responsibility Principle - handles only layer/component generation
    module LayerComponentGenerator
      private

      def generate_layer(base_path:, layer_name:, layer_config:)
        layer_path = File.join(base_path, layer_name.to_s)
        FileUtils.mkdir_p(layer_path)

        layer_config.components.each do |component|
          generate_component(
            layer_path: layer_path,
            component: component,
            layer_config: layer_config
          )
        end
      end

      def generate_component(layer_path:, component:, layer_config:)
        component_name = resolve_component_name(component: component, layer_config: layer_config)
        file_path = File.join(layer_path, "#{component_name}.rb")
        content = generate_component_content(component: component, layer_config: layer_config)

        generate_file?(file_path, content)
      end

      def resolve_component_name(component:, layer_config:)
        if component.is_a?(Hash)
          name = component.keys.first.to_s
          suffix = component.values.first[:suffix]
        else
          name = component == :domain ? @name.to_s : component.to_s
          suffix = layer_config.default_suffix
        end

        suffix && suffix != false ? "#{name}_#{layer_config.layer_name}" : name
      end

      def generate_component_content(component:, layer_config:)
        class_name = generate_class_name(component: component, layer_config: layer_config)

        if layer_config.is_a?(OperationLayer)
          generate_component_operation_content(
            component: component,
            class_name: class_name,
            layer_config: layer_config
          )
        else
          generate_standard_content(
            component: component,
            class_name: class_name,
            layer_config: layer_config
          )
        end
      end

      def generate_class_name(component:, layer_config:)
        if component.is_a?(Hash)
          base_name = component.keys.first.to_s.camelize
          suffix    = component.values.first[:suffix]
        else
          name = component == :domain ? @name : component
          base_name = name.to_s.camelize
          suffix = layer_config.default_suffix
        end

        suffix && suffix != false ? "#{base_name}#{layer_config.layer_name.to_s.camelize}" : base_name
      end

      def generate_standard_content(component:, class_name:, layer_config:)
        base_requirement = layer_config.base_class ? "require_relative '#{layer_config.base_class}'\n\n" : ''
        base_class_inheritance = (" < #{layer_config.base_class.split('/').last.camelize}" if layer_config.base_class)

        <<~RUBY
          # frozen_string_literal: true
          # Generated at #{Time.now.strftime('%Y%m%d%H%M%S')}
          #{base_requirement}class #{class_name}#{base_class_inheritance}
            # TODO: Implement #{class_name} logic
          end
        RUBY
      end
    end
  end
end
