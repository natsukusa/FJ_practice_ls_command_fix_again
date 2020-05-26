# frozen_string_literal: true

module Ls
  class Formatter
    attr_reader :option, :argv

    def initialize(option, argv)
      @option = option
      @argv = argv
    end

    def argv_files
      @argv.select{ |v| File.file?(v)}
    end

    def argv_directories
      @argv.select{ |v| File.directory?(v)}
    end

    def directory_name_required?
      (argv_files.length + argv_directories.length) > 1
    end

    def sort_and_reverse(array)
      @option[:reverse] ? array.sort.reverse : array.sort
    end

    def make_name_list
      @option[:all] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    end






  end
end
