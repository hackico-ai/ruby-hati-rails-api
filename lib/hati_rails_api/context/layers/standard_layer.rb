# frozen_string_literal: true

module HatiRailsApi
  module Context
    # Standard layer configuration class
    # Follows Single Responsibility Principle - handles standard layer configuration
    class StandardLayer
      attr_reader :layer_name, :base_class, :components, :default_suffix

      def initialize(layer_name)
        @layer_name = layer_name
        @base_class = nil
        @components = []
        @default_suffix = true
      end

      def base(base_class)
        @base_class = base_class
      end

      def component(*names, **options)
        if names.empty?
          @components = [:domain]
        else
          names.each do |name|
            if name.is_a?(Array)
              @components.concat(name)
            else
              @components << (options.empty? ? name : { name => options })
            end
          end
        end
      end

      def dup
        new_layer = self.class.new(@layer_name)
        new_layer.instance_variable_set(:@base_class, @base_class)
        new_layer.instance_variable_set(:@components, @components.dup)
        new_layer.instance_variable_set(:@default_suffix, @default_suffix)
        new_layer
      end
    end
  end
end
