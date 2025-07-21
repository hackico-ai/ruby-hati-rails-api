# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/base'

module HatiRailsApi
  module Generators
    # Rails generator for HatiRailsApi context operations
    # Provides Rails integration for the context system with migration-style workflow
    class ContextGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      argument :command, type: :string, default: 'init',
                         desc: 'Command: init, run, rollback, list, or domain name for quick generation'

      class_option :force, type: :boolean, default: false,
                           desc: 'Force overwrite existing files'

      class_option :timestamp, type: :string,
                               desc: 'Timestamp for rollback operation'

      class_option :operations, type: :array, default: [],
                                desc: 'Operations to generate for the domain'

      class_option :endpoint, type: :boolean, default: true,
                              desc: 'Generate API endpoint for the domain'

      def perform_command
        case command.downcase
        when 'init', 'initialize'
          initialize_context
        when 'run', 'execute'
          run_migrations
        when 'rollback', 'rb'
          rollback_generation
        when 'list', 'ls'
          list_generations
        else
          # Treat as domain name for migration creation
          create_domain_migration(command)
        end
      end

      private

      def initialize_context
        say 'Initializing HatiRailsApi Context System...', :green
        create_configuration_files
        create_directory_structure
        create_example_migration
        say "\nContext system initialized successfully!", :green
        say 'Check the generated files and examples to get started.', :blue
        say "\nMigration-style workflow:", :yellow
        say '  1. rails generate hati_rails_api:context user        # Create domain migration'
        say '  2. rails generate hati_rails_api:context run         # Execute migrations'
        say '  3. rails generate hati_rails_api:context rollback    # Rollback last'
        say '  4. rails generate hati_rails_api:context list        # Show generations'
      end

      def create_domain_migration(domain_name)
        say "Creating migration for domain: #{domain_name}", :green
        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        migration_file = "config/contexts/#{timestamp}_create_#{domain_name}_context.rb"
        operations = if options[:operations].any?
                       options[:operations].flat_map { |op| op.split(',') }.map(&:strip)
                     else
                       ['create', 'update', 'destroy']
                     end
        endpoint_enabled = options[:endpoint]
        create_file migration_file, domain_migration_template(domain_name, operations, endpoint_enabled)
        say "Migration created: #{migration_file}", :green
        say 'Edit the migration file to customize the domain configuration', :blue
        say 'Run: rails generate hati_rails_api:context run', :yellow
      end

      def run_migrations
        say 'Running context migrations...', :green
        migration_files = Dir[Rails.root.join('config', 'contexts', '*_create_*_context.rb')].sort
        if migration_files.empty?
          say_error 'No context migrations found!'
          say 'Create a domain migration first: rails generate hati_rails_api:context user'
          return
        end
        require_context_system
        configure_defaults unless HatiRailsApi::Context.configured?
        executed_count = 0
        migration_files.each do |migration_file|
          executed_count += 1 if execute_migration(migration_file)
        end
        if executed_count > 0
          say "Successfully executed #{executed_count} migration(s)!", :green
          say 'Use --force to override all existing files without prompting', :yellow unless options[:force]
        else
          say 'No new migrations to execute', :blue
        end
      end

      def execute_migration(migration_file)
        say "Executing: #{File.basename(migration_file)}", :yellow
        begin
          require_context_system
          configure_defaults unless HatiRailsApi::Context.configured?
          migration_content = File.read(migration_file)
          if migration_content.include?('< HatiRailsApi::Context::Migration')
            load migration_file
          else
            HatiRailsApi::Context.generate(force: options[:force]) do |ctx|
              ctx.instance_eval(migration_content, migration_file)
            end
          end
          say "Completed: #{File.basename(migration_file)}", :green
          true
        rescue StandardError => e
          say_error "Error executing #{File.basename(migration_file)}: #{e.message}"
          say_error "Location: #{e.backtrace&.first}"
          false
        end
      end

      def rollback_generation
        say 'Rolling back generation...', :yellow
        require_context_system
        result = if options[:timestamp]
                   HatiRailsApi::Context.rollback(options[:timestamp])
                 else
                   HatiRailsApi::Context.rollback
                 end
        if result
          say 'Rollback completed successfully!', :green
        else
          say_error 'Rollback failed!'
        end
      end

      def list_generations
        say 'Listing all generations...', :blue
        require_context_system
        HatiRailsApi::Context.list_generations
      end

      def create_configuration_files
        create_file 'config/contexts.rb', global_config_template
        create_file 'config/contexts/.gitkeep', ''
      end

      def create_directory_structure
        empty_directory 'app/contexts'
        create_file 'app/contexts/.gitkeep', ''
      end

      def create_example_migration
        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        create_file "config/contexts/#{timestamp}_create_example_context.rb", example_migration_template
      end

      def require_context_system
        require File.expand_path('../../hati_rails_api/context', __dir__)
      end

      def configure_defaults
        HatiRailsApi::Context.configure do |config|
          config.base_path 'app/contexts'
          config.model path: 'app/models', base: 'ApplicationRecord'
          config.endpoint path: 'app/controllers/api', base: 'ApplicationController'
        end
      end

      def global_config_template
        <<~RUBY
          # frozen_string_literal: true

          # HatiRailsApi Global Context Configuration
          # This file contains global settings for the context system

          require 'hati_rails_api/context'

          # Configure global settings
          HatiRailsApi::Context.configure do |config|
            config.base_path 'app/contexts'
            config.model path: 'app/models', base: 'ApplicationRecord'
            config.endpoint path: 'app/controllers/api', base: 'ApplicationController'
          end

          # Global domain configuration (applies to all domains)
          HatiRailsApi::Context.configure do |config|
            config.domain do |domain|
              # Default operation layer with common base
              domain.operation do |operation|
                operation.base 'hati_operation/base'
              end
            end
          end
        RUBY
      end

      def domain_migration_template(domain_name, operations, endpoint_enabled)
        operation_list = operations.map(&:to_sym).inspect
        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        class_name = "Create#{domain_name.camelize}Context"
        <<~RUBY
          # frozen_string_literal: true

          # Context Migration: Create #{domain_name.camelize} Domain
          # Generated at #{Time.now}

          class #{class_name} < HatiRailsApi::Context::Migration
            def change
              domain :#{domain_name} do |domain|
                # Define operations for this domain
                domain.operation do |operation|
                  operation.component #{operation_list}
                end
                # API endpoint configuration
                domain.endpoint #{endpoint_enabled}
                # Optional: Add custom layers
                # domain.validation do |validation|
                #   validation.component [:input_validator, :business_validator]
                # end
                # domain.query do |query|
                #   query.component [:finder, :searcher]
                # end
                # domain.service do |service|
                #   service.component [:mailer, :notifier]
                # end
                # domain.serializer do |serializer|
                #   serializer.component [:json_serializer, :xml_serializer]
                # end
              end
              # Optional: Generate domain-specific models
              # model [:#{domain_name}]
              # Optional: Generate additional endpoints
              # endpoint [:#{domain_name}_status]
            end
          end

          #{class_name}.new.run
        RUBY
      end

      def example_migration_template
        <<~RUBY
          # frozen_string_literal: true

          # Example Context Migration
          # This is an example - you can safely delete this file

          # ctx.domain :ecommerce do |domain|
          #   domain.operation do |operation|
          #     operation.component [:payment_processing, :inventory_management, :order_fulfillment]
          #   end
          #   domain.endpoint enabled: true
          #   domain.service do |service|
          #     service.component [:notification, :analytics]
          #   end
          #   domain.query do |query|
          #     query.component [:product_finder, :order_searcher]
          #   end
          # end

          # ctx.model [:product, :order, :customer]
          # ctx.endpoint [:health, :metrics]
        RUBY
      end

      def say_error(message)
        say message, :red
      end
    end
  end
end
