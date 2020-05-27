# frozen_string_literal: true

require 'io/console/size'
require './ls_file_data.rb'

module Ls
  class Formatter
    attr_reader :option, :argv

    def initialize(option, argv)
      @option = option
      @argv = argv
    end

    def generate
      puts generate_with_argv_files unless argv_files.empty?
      puts generate_with_directory(Dir.pwd) if @argv.empty?
      puts generate_with_argv_directories unless argv_directories.empty?
    end

    private

    def generate_with_argv_files
      file_details = (sort_and_reverse(argv_files).map { |file| FileData.new(file) })
      if @option[:list]
        list_view(file_details).last(file_details.length)
      else
        name_view(file_details)
      end
    end

    def generate_with_directory(directory)
      Dir.chdir(directory) do
        name_list = @option[:all] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
        file_details = sort_and_reverse(name_list).map { |file| FileData.new(file) }
        @option[:list] ? list_view(file_details) : name_view(file_details)
      end
    end

    def generate_with_argv_directories
      views = []
      sort_and_reverse(argv_directories).each do |directory|
        views << "\n" unless views.empty? && argv_files.empty?
        views << "#{directory}:" unless argv_directories.length == 1 && argv_files.empty?
        views << generate_with_directory(directory)
      end
      views
    end

    def list_view(file_details)
      array = ["total #{file_details.map(&:blocks).sum}"]
      array << file_details.map do |f|
        "#{f.ftype}#{f.mode}  "\
        "#{f.format_max_nlink_digit(file_details, f)} "\
        "#{f.owner.rjust(5)}  #{f.group}  "\
        "#{f.format_max_size_digit(file_details, f)} "\
        "#{f.mtime} #{f.file}"\
      end
      array
    end

    def name_view(file_details)
      columns_width = columns_width(file_details)
      number_of_rows = number_of_rows(file_details)
      formatted_list = file_details.map { |f| f.file.ljust(columns_width) }
      sliced_list = formatted_list.each_slice(number_of_rows).to_a
      sliced_list.last << '' while sliced_list.last.size < number_of_rows
      sliced_list.transpose.map(&:join)
    end

    def console_width
      IO.console_size[1]
    end

    def columns_width(file_details)
      max_file_length = file_details.map { |f| f.file.length }.max
      ((max_file_length + 1) / 8.0).ceil * 8
    end

    def number_of_rows(file_details)
      number_of_columns = console_width / columns_width(file_details)
      (file_details.size / number_of_columns.to_f).ceil
    end

    def argv_files
      @argv.select { |f| File.file?(f) }
    end

    def argv_directories
      @argv.select { |d| File.directory?(d) }
    end

    def sort_and_reverse(array)
      @option[:reverse] ? array.sort.reverse : array.sort
    end
  end
end
