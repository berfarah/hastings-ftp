module Hastings
  module FTP
    # FTP File
    class File
      attr_reader :path, :ftp

      def initialize(path, ftp)
        @path = path
        @ftp  = ftp
      end

      def file?(path)
        ftp.file?(path)
      end

      def basename
        ::File.basename(path)
      end

      def dirname
        ::File.dirname(path)
      end

      def copy_to(destination, overwrite: true)
        return false if !overwrite && dest_exist?(destination)
        ftp.get(path, destination)
      end

      def move_to(destination, overwrite: true)
        copy_to(destination, overwrite: overwrite)
        ftp.delete(path)
      end

      # Modified at
      def mtime
        ftp.mtime(path)
      end

      def newer_than?(time)
        mtime > time
      end

      def older_than?(time)
        mtime < time
      end

      private

        def copy_to_ftp(dest)
          Tempfile.open do |tmp|
            copy_to(tmp.path)
            dest.copy_from(tmp.path)
          end
        end

        def move_to_ftp(dest)
          ftp.rename(dest.join basename)
        end

        def dest_exist?(to)
          File.file?(to) ||
            Dir.exist?(to) && File.file?(File.join to, basename)
        end
    end
  end
end
