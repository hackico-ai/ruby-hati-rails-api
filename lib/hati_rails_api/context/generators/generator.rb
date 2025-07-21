# frozen_string_literal: true

require_relative 'base_generator'
require_relative 'domain_generator'
require_relative '../managers/rollback_manager'
require_relative '../shared/content_generators'

module HatiRailsApi
  module Context
    # Main orchestrator for the generation process
    # Coordinates all generation activities with clean separation of concerns
    class Generator < BaseGenerator
      include ContentGenerators

      # Default configurations for models and endpoints
      DEFAULT_MODEL = { path: 'app/models', base: 'ApplicationRecord' }.freeze
      DEFAULT_ENDPOINT = { path: 'app/controllers/api', base: 'ApplicationController' }.freeze

      attr_reader :domains, :models, :endpoints

      def initialize(config = nil, force: false)
        super
        @domains = {}
        @models = []
        @endpoints = []
      end

      # Register global models for generation
      #
      # @param names_or_options [String, Array, Hash] Model names or options
      # @param options [Hash] Additional options
      def model(names_or_options = nil, **options)
        return unless names_or_options

        names, opts = extract_names_and_options(names_or_options, options)
        names.each { |name| @models << { name: name, options: opts } }
      end

      # Register global endpoints for generation
      #
      # @param names_or_options [String, Array, Hash] Endpoint names or options
      # @param options [Hash] Additional options
      def endpoint(names_or_options = nil, **options)
        return unless names_or_options

        names, opts = extract_names_and_options(names_or_options, options)
        names.each { |name| @endpoints << { name: name, options: opts } }
      end

      # Define a domain with its configuration
      #
      # @param name [Symbol, String] Domain name
      # @param options [Hash] Domain-specific options
      # @param block [Proc] Domain configuration block
      def domain(name, **options, &block)
        domain_generator = create_domain_generator(name, options)
        domain_generator.instance_eval(&block) if block_given?
        @domains[name] = domain_generator
      end

      # Execute the complete generation process
      #
      # @return [Boolean] True if generation was successful
      def execute
        return false if nothing_to_generate?

        generate_all_components
        track_generation_results
        true
      end

      private

      # Extract names and options from flexible parameter format
      def extract_names_and_options(names_or_options, options)
        if names_or_options.is_a?(Hash)
          [[], names_or_options]
        else
          names = Array(names_or_options)
          [names, options]
        end
      end

      # Create a properly configured domain generator
      def create_domain_generator(name, options)
        DomainGenerator.new(
          name: name,
          config: @config,
          options: options,
          generated_files: @generated_files,
          force: @force,
          override_all: method(:override_all_state)
        ).tap do |generator|
          generator.context_reference = self
        end
      end

      # Check if there's anything to generate
      def nothing_to_generate?
        @models.empty? && @endpoints.empty? && @domains.empty?
      end

      # Generate all components in the correct order
      def generate_all_components
        generate_global_models
        generate_global_endpoints
        generate_domains
      end

      # Generate all registered global models
      def generate_global_models
        @models.each { |model_config| generate_single_model(model_config) }
      end

      # Generate all registered global endpoints
      def generate_global_endpoints
        @endpoints.each { |endpoint_config| generate_single_endpoint(endpoint_config) }
      end

      # Generate all defined domains
      def generate_domains
        @domains.each_value(&:generate)
      end

      # Generate a single model with error handling
      def generate_single_model(model_config)
        file_path = model_file_path(model_config)
        content = model_content(model_config)

        generate_file?(file_path, content)
      end

      # Generate a single endpoint with error handling
      def generate_single_endpoint(endpoint_config)
        file_path = endpoint_file_path(endpoint_config)
        content = endpoint_content(endpoint_config)

        generate_file?(file_path, content)
      end

      # Build model file path
      def model_file_path(model_config)
        path = resolve_model_path(model_config[:options])
        File.join(path, "#{model_config[:name]}.rb")
      end

      # Build endpoint file path
      def endpoint_file_path(endpoint_config)
        path = resolve_endpoint_path(endpoint_config[:options])
        File.join(path, "#{endpoint_config[:name]}_controller.rb")
      end

      # Generate model content
      def model_content(model_config)
        generate_model_content(
          name: model_config[:name],
          base_class: resolve_model_base_class,
          timestamp: @timestamp
        )
      end

      # Generate endpoint content
      def endpoint_content(endpoint_config)
        generate_controller_content(
          name: endpoint_config[:name],
          base_class: resolve_endpoint_base_class,
          timestamp: @timestamp
        )
      end

      # Resolve model path with fallbacks
      def resolve_model_path(options)
        options[:path] ||
          @config&.model_config&.dig(:path) ||
          DEFAULT_MODEL[:path]
      end

      # Resolve model base class with fallbacks
      def resolve_model_base_class
        @config&.model_config&.dig(:base) || DEFAULT_MODEL[:base]
      end

      # Resolve endpoint path with fallbacks
      def resolve_endpoint_path(options)
        options[:path] ||
          @config&.endpoint_config&.dig(:path) ||
          DEFAULT_ENDPOINT[:path]
      end

      # Resolve endpoint base class with fallbacks
      def resolve_endpoint_base_class
        @config&.endpoint_config&.dig(:base) || DEFAULT_ENDPOINT[:base]
      end

      # Track generation results for rollback functionality
      def track_generation_results
        return if @generated_files.empty?

        RollbackManager.new.track_generation(@timestamp, @generated_files)
        log_generation_summary
      end

      # Log a summary of the generation results
      def log_generation_summary
        puts "\nGeneration completed successfully!"
        puts "   Timestamp: #{@timestamp}"
        puts "   Files generated: #{@generated_files.length}"
        puts "   To rollback: rails generate hati_rails_api:context rollback --timestamp=#{@timestamp}"
      end
    end
  end
end
