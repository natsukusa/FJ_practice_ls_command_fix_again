# frozen_string_literal: true

module Ls
  class Directory
    def initialize(directory)
      @directory = directory
    end

    def generate_at_argv_files
      file_names = sort_and_reverse(Argv.files).map { |file| FileData.new(file) }
      finalize(file_names)
    end

    def generate_with_directories
      array = []
      Dir.chdir(@directory) do
        file_names = sort_and_reverse(look_up_dir).map { |file| FileData.new(file) }
        array << "total #{file_names.map(&:fill_blocks).sum}"
        array << finalize(file_names)
      end
      array
    end

    def finalize(file_details)
      file_details.map do |f|
        "#{f.fill_ftype}#{f.fill_mode}  "\
        "#{f.format_max_nlink_digit(file_details, f)} "\
        "#{f.fill_owner.rjust(5)}  #{f.fill_group}  "\
        "#{f.format_max_size_digit(file_details, f)} "\
        "#{f.fill_mtime} #{f.file}"\
      end
    end

    def look_up_dir
      Argv.option[:all] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    end

    def sort_and_reverse(array)
      Argv.option[:reverse] ? array.sort.reverse : array.sort
    end
  end
end
