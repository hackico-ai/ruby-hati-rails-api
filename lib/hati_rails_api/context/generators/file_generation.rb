# frozen_string_literal: true

require 'fileutils'

module HatiRailsApi
  module Context
    # Shared concern for file generation operations
    # Eliminates duplicate file handling code across generators
    module FileGeneration
      ALL_RGX = [/^a/, /all/, /^a=all$/].freeze
      SKIP_RGX = [/^s/, /skip/, /^s=skip$/].freeze
      YES_RGX = [/^y/, /yes$/].freeze
      NO_RGX = [/^n/, /no$/].freeze

      def generate_file?(file_path, content)
        FileUtils.mkdir_p(File.dirname(file_path))

        if create_file?(file_path)
          File.write(file_path, content)
          @generated_files << file_path
          puts "Created: #{file_path}"
          true
        else
          puts "Skipped: #{file_path} (already exists or user declined)"
          false
        end
      end

      def create_file?(file_path)
        return true unless File.exist?(file_path)
        return true if @force
        return override_all? unless override_all?.nil?

        prompt_for_override(file_path)
      end

      def override_all?
        return @override_all_ref.call(:get) if shared_override_state?

        @override_all
      end

      def shared_override_state?
        respond_to?(:use_shared_override_state?) && use_shared_override_state?
      end

      def prompt_for_override(file_path)
        print "File '#{file_path}' already exists. Override? (y/N/a=all/s=skip all): "
        handle_override_response($stdin.gets&.chomp&.downcase || 'n')
      end

      def handle_override_response(response)
        case response
        when *ALL_RGX  then self.override_all_state = true
        when *SKIP_RGX then self.override_all_state = false
        when *YES_RGX  then true
        else false
        end
      end

      def override_all_state=(value)
        use_shared = respond_to?(:use_shared_override_state?) && use_shared_override_state?

        use_shared ? @override_all_ref&.call(value) : @override_all = value
      end

      def use_shared_override_state?
        @override_all_ref&.respond_to?(:call)
      end
    end
  end
end
