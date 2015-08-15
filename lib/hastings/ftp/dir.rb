module Hastings
  module FTP
    # FTP Dir
    class Dir
      attr_reader :path, :ftp

      def initialize(path, ftp)
        @path = path
        @ftp  = ftp
      end

      def exist?(path)
        ftp.dir?(path)
      end

      # Upload local files - belongs in FTP module rather than File class
      def copy_from(local)
        ftp.put(local, join(local))
      end

      def move_from(local)
        copy_from(local)
        Hastings::File.delete(local)
      end

      def join(file_path)
        [path, Hastings::File.basename(file_path)].join("/")
      end
    end
  end
end
