# encoding: utf-8

module CartoDB
  module Relocator
    module Helpers
      def token
        "token#{relocation_id.delete('-')}" 
      end #token

      def database_username
        "#{environment}_cartodb_user_#{user.id}"
      end #database_username

      def user_database_for(user_id)
        "cartodb_#{environment}_user_#{user_id}_db"
      end #user_database

      def to_stdout(text)
        marker = '=' * 10
        puts [Time.now, marker, text].join(' ')
      end #to_stdout

      def print_and_raise(stderr)
        puts
        puts '*' * 80
        puts
        puts ' ' * 10 + "COMMAND EXITED WITH ERRORS"
        puts
        puts stderr.read
        puts
        puts '*' * 80
        puts
        raise 'Command exited with errors'
      end #print_and_raise

      def url_for(path)
        bucket = ENV['S3_BUCKET']
        "https://s3.amazonaws.com/#{bucket}/#{path}"
      end #url_for
    end # Helpers
  end # Relocator
end # CartoDB

