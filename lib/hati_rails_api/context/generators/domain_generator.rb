# frozen_string_literal: true

require_relative 'base_generator'
require_relative '../shared/layer_factory'
require_relative 'file_generation'
require_relative 'model_endpoint_generator'
require_relative 'layer_component_generator'
require_relative 'operation_generator'

module HatiRailsApi
  module Context
    # Domain generator class for handling domain-specific generation
    # Follows Single Responsibility Principle - handles domain context generation
    class DomainGenerator
      include LayerFactory
      include FileGeneration
      include ModelEndpointGenerator
      include LayerComponentGenerator
      include OperationGenerator

      DEFAULT_DOMAIN_STATE = { enabled: false }.freeze
      CONTEXT_PATH = 'app/contexts'
      HATI_OPERATION_BASE = 'hati_operation/base'
      DEFAULT_OPTIONS = {}.freeze
      DEFAULT_FILES = [].freeze

      attr_reader :name, :config, :layers, :options

      def initialize(
        name:,
        config:,
        options: DEFAULT_OPTIONS,
        generated_files: DEFAULT_FILES,
        force: false,
        override_all: nil
      )
        @name = name
        @config = config
        @options = options
        @generated_files = generated_files
        @force = force
        @override_all = override_all

        @domain_model = DEFAULT_DOMAIN_STATE.dup
        @domain_endpoint = DEFAULT_DOMAIN_STATE.dup

        @layers = {}
        @ctx_reference = nil

        setup_layers
      end

      def operation(&block)
        @layers[:operation] = create_operation_layer(&block)
      end

      def layer(name, &block)
        @layers[name.to_sym] = create_standard_layer(name, &block)
      end

      def model(enabled_or_options = true, **options)
        @domain_model =
          case enabled_or_options
          when false
            DEFAULT_DOMAIN_STATE
          when Hash
            { enabled: true, options: enabled_or_options }
          else
            { enabled: true, options: options }
          end
      end

      def endpoint(enabled_or_components = true, components: [], **options)
        # Handle different argument patterns:
        # endpoint true
        # endpoint enabled: true
        # endpoint [:comp1, :comp2]
        # endpoint enabled: true, components: [:comp1]

        enabled =
          case enabled_or_components
          when Array
            true
          when Hash
            enabled_or_components.fetch(:enabled, true)
          else
            enabled_or_components
          end

        components_to_use =
          case enabled_or_components
          when Array
            enabled_or_components
          else
            components
          end

        @domain_endpoint = create_endpoint_state(enabled, components_to_use, options)
      end

      def generate
        generate_domain_model    if @domain_model[:enabled]
        generate_domain_endpoint if @domain_endpoint[:enabled]
        generate_layers
      end

      def context_reference=(ctx)
        @ctx_reference = ctx
      end

      private

      def generate_layers
        base_path = File.join(@config&.base_path || CONTEXT_PATH, @name.to_s)

        # Safety check: remove file if contexts exists as file instead of directory
        contexts_root = @config&.base_path || CONTEXT_PATH
        File.delete(contexts_root) if File.exist?(contexts_root) && !File.directory?(contexts_root)

        FileUtils.mkdir_p(base_path)

        @layers.each do |layer_name, layer_config|
          generate_layer(
            base_path: base_path,
            layer_name: layer_name,
            layer_config: layer_config
          )
        end
      end

      def setup_layers
        if options[:layers]
          copy_default_layers
          setup_specific_layers
        else
          copy_default_layers
        end
      end

      def setup_specific_layers
        requested_layers = options[:layers]
        requested_components = options[:components]

        setup_requested_layers(requested_layers, requested_components)
        cleanup_unrequested_layers(requested_layers)
      end

      def setup_requested_layers(layers, components)
        layers.each do |layer_name|
          if @layers[layer_name]
            update_existing_layer(layer_name, components)
          else
            create_new_layer(layer_name, components)
          end
        end
      end

      def update_existing_layer(name, components)
        layer = @layers[name]
        layer.component(components) if components
      end

      def create_new_layer(name, components)
        @layers[name] =
          if name == :operation
            create_operation_layer_with_components(components)
          else
            create_standard_layer_with_components(name, components)
          end
      end

      def create_operation_layer_with_components(components)
        OperationLayer.new.tap do |layer|
          layer.base(HATI_OPERATION_BASE)
          layer.component(components) if components
        end
      end

      def create_standard_layer_with_components(name, components)
        StandardLayer.new(name).tap do |layer|
          layer.base("application_#{name}")
          layer.component(components) if components
        end
      end

      def cleanup_unrequested_layers(requested_layers)
        @layers.select! { |name, _| requested_layers.include?(name) }
      end

      def copy_default_layers
        return unless @config&.domain_config&.layers

        @config.domain_config.layers.each do |name, layer|
          @layers[name] = layer.dup
        end
      end

      def method_missing(method_name, ...)
        result = create_dynamic_layer(method_name, ...)
        return super unless result

        @layers[method_name.to_sym] = result
      end

      def respond_to_missing?(_method_name, _include_private = false)
        true
      end

      def create_endpoint_state(enabled, components, options)
        case enabled
        when false then DEFAULT_DOMAIN_STATE
        when true  then { enabled: true, options: options, explicit_components: components.empty? ? nil : components }
        when Array then { enabled: true, options: options, explicit_components: enabled }
        when Hash  then { enabled: true, options: enabled, explicit_components: nil }
        end
      end
    end
  end
end
