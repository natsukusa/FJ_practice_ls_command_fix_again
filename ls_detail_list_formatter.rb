# frozen_string_literal: true

require './ls_file_data.rb'
require './ls_formatter'

module Ls
  class DetailListFormatter < Formatter
    def generate
      views = []
      views << list_view(sort_and_reverse(argv_files).map { |file| FileData.new(file) })
      views << generate_with_argv_directories unless argv_directories.empty?
      views << generate_with_directory(Dir.pwd) if @argv.empty?
      puts views
    end

    def generate_with_argv_directories
      views = []
      directories = sort_and_reverse(argv_directories)
      directories.each do |directory|
        views << "\n" unless views.empty? && argv_files.empty?
        views << "#{directory}:" if directory_name_required?
        views << generate_with_directory(directory)
      end
      views
    end

    def generate_with_directory(directory)
      array = []
      Dir.chdir(directory) do
        file_details = sort_and_reverse(make_name_list).map { |file| FileData.new(file) }
        array << "total #{file_details.map(&:fill_blocks).sum}"
        array << list_view(file_details)
      end
      array
    end

    def list_view(file_details)
      file_details.map do |f|
        "#{f.fill_ftype}#{f.fill_mode}  "\
        "#{f.format_max_nlink_digit(file_details, f)} "\
        "#{f.fill_owner.rjust(5)}  #{f.fill_group}  "\
        "#{f.format_max_size_digit(file_details, f)} "\
        "#{f.fill_mtime} #{f.file}"\
      end
    end

  end
end
