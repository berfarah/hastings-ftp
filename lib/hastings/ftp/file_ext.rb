require "hastings/file"

module Hastings
  module FTP
    module FileExt
      # Interactory methods are adjusted for ftp destinations
      module Core
        # include Hastings::File::Core

        # def copy_to(dir, overwrite: true)
        #   return dir.copy_from(path) if ftp? dir
        #   super
        # end

        # def move_to(dir, overwrite: true)
        #   return dir.move_from(path) if ftp? dir
        #   super
        # end

        # private

        #   def ftp?(obj)
        #     obj.is_a? Hastings::FTP::Dir
        #   end
      end
    end
  end

  # Include our FTP module in the base File
  class File
    include Hastings::FTP::FileExt::Core
  end
end
