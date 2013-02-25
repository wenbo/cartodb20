# encoding: utf-8 
require 'fileutils'
require 'zip/zip'

module DataRepository
  module Filesystem
    class Local
      DEFAULT_PREFIX = File.join(File.dirname(__FILE__), '..', 'tmp')

      def initialize(base_directory=DEFAULT_PREFIX)
        @base_directory = base_directory
      end #initialize

      def store(path, data)
        FileUtils.mkpath( File.dirname( destination_for(path) ) )

        if data.respond_to?(:bucket)
          data.read { |chunk| file.write(chunk)}
        end
        
        File.open(destination_for(path), 'w') do |file|
          while chunk = data.gets
            file.write(chunk) 
          end
        end unless data.respond_to?(:bucket)

        path
      end #store

      def fetch(path)
        File.open(destination_for(path), 'r')
      end #fetch

      def zip(path)
        zip_path = "#{destination_for(path)}.zip"

        Zip::ZipFile.open(zip_path, true) do |zipfile|
          Dir.glob("#{destination_for(path)}/**/*") do |filepath|
            next if (filepath == '.' || filepath == '..')
            zipfile.add(File.absolute_path(filepath, path), filepath)
          end
        end

        zip_path
      end #zip

      def unzip(path)
      end #unzip

      private

      attr_reader :base_directory

      def destination_for(path)
        File.join(base_directory, path)
      end #destination_for
    end # Local
  end # Filesystem
end # DataRepository

