require "net/ftp"
require "forwardable"

module Hastings
  module FTP
    # Isolating into module just in case
    class Connection
      extend Forwardable
      attr_reader :connection

      def initialize(host, port: 21, user: nil, password: nil)
        @connection = Net::FTP.new
        @connection.connect(host, port)
        @connection.login(user, password) if user
      end

      def_delegators :@connection,
                     :login, :close, :closed?,            # Server
                     :get, :put, :delete, :rename,        # General
                     :chdir, :mkdir, :rmdir, :nlst, :pwd, :list, # Directory
                     :mtime, :size                        # File

      def mkdir_p(path)
        mkdir(path); rescue; nil
      end

      def dir?(path)
        with_dir(dirname path) { chdir(basename path) }
        true
      rescue Net::FTPError; false
      end

      def exist?(path)
        with_dir(dirname path) { nlst.include?(basename path) }
      end

      def file?(path)
        exist?(path) && !dir?(path)
      end

      private

        def with_dir(dir)
          return yield unless dir
          pwd_ = pwd
          chdir(dir)
          yield.tap { chdir(pwd_) }
        end

        def dirname(path)
          %r{^(?<dirname>[^/]+)/[^/]+$} =~ path
          dirname
        end

        def basename(path)
          %r{(?<basename>[^/]+)$} =~ path
          basename
        end
    end
  end
end
