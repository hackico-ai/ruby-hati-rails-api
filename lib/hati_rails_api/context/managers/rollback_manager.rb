# frozen_string_literal: true

require 'fileutils'
require 'yaml'

module HatiRailsApi
  module Context
    # Manages rollback functionality for generated files
    # Follows Single Responsibility Principle - only handles rollback operations
    class RollbackManager
      TRACKING_FILE = 'config/contexts/.hati_generations.yml'

      def initialize
        ensure_tracking_directory
      end

      def track_generation(timestamp, files)
        tracking_data = load_tracking_data
        tracking_data[timestamp] = {
          'generated_at' => Time.now.to_s,
          'files' => files
        }
        save_tracking_data(tracking_data)
      end

      def rollback_by_timestamp?(timestamp)
        tracking_data = load_tracking_data
        generation = tracking_data[timestamp]

        unless generation
          puts "No generation found with timestamp: #{timestamp}"
          puts "Available generations: #{tracking_data.keys.join(', ')}"
          return false
        end

        rollback_files(generation['files'], timestamp)

        # Remove from tracking
        tracking_data.delete(timestamp)
        save_tracking_data(tracking_data)

        puts "Rollback completed for timestamp: #{timestamp}"
        true
      end

      def rollback_last?
        tracking_data = load_tracking_data

        if tracking_data.empty?
          puts 'No generations to rollback'
          return false
        end

        last_timestamp = tracking_data.keys.sort.last
        rollback_by_timestamp?(last_timestamp)
      end

      def list_generations
        tracking_data = load_tracking_data

        if tracking_data.empty?
          puts 'No context generations found'
          return
        end

        puts "\nContext Generations:"
        puts '=' * 50

        tracking_data.each do |timestamp, data|
          puts "#{timestamp} (#{data['generated_at']})"
          puts "   Files: #{data['files'].size} files"
          data['files'].each { |file| puts "   - #{file}" }
          puts ''
        end
      end

      private

      def load_tracking_data
        return {} unless File.exist?(TRACKING_FILE)

        YAML.load_file(TRACKING_FILE) || {}
      rescue StandardError
        {}
      end

      def save_tracking_data(data)
        File.write(TRACKING_FILE, data.to_yaml)
      end

      def ensure_tracking_directory
        FileUtils.mkdir_p(File.dirname(TRACKING_FILE))
      end

      def rollback_files(files, timestamp)
        puts "Rolling back generation #{timestamp}..."

        files.each do |file_path|
          if File.exist?(file_path)
            FileUtils.rm(file_path)
            puts "   Removed: #{file_path}"
          else
            puts "   Already removed: #{file_path}"
          end

          # Clean up empty directories
          remove_empty_directories(File.dirname(file_path))
        end
      end

      def remove_empty_directories(dir)
        return unless Dir.exist?(dir)
        return if ['app', 'app/contexts'].include?(dir) # Don't remove base directories

        return unless Dir.empty?(dir)

        FileUtils.rmdir(dir)
        puts "   Removed empty directory: #{dir}"
        remove_empty_directories(File.dirname(dir))
      end
    end
  end
end
