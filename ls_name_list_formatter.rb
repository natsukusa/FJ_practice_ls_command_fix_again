# frozen_string_literal: true

require 'io/console/size'
require './ls_formatter'

module Ls
  class NameListFormatter < Formatter

    def generate
      views = []
      views << make_name_view(sort_and_reverse(argv_files)) unless argv_files.empty?
      views << generate_with_argv_directories unless argv_directories.empty?
      views << make_name_view(sort_and_reverse(make_name_list)) if @argv.empty?
      puts views
    end

    def generate_with_argv_directories
      views = []
      directories = sort_and_reverse(argv_directories)
      directories.each do |directory|
        views << "\n" unless views.empty? && argv_files.empty?
        views << "#{directory}:" if directory_name_required?
        file_names = Dir.chdir(directory) { sort_and_reverse(make_name_list) }
        views << make_name_view(file_names)
      end
      views
    end

    def console_width
      IO.console_size[1]
    end

    # @columns_width = 8, 16, 24, 32, 40, 48 ...
    def columns_width(file_names)
      max_file_length = file_names.max_by(&:length).length
      ((max_file_length + 1) / 8.0).ceil * 8
    end

    def number_of_rows(file_names)
      number_of_columns = console_width / columns_width(file_names)
      (file_names.size / number_of_columns.to_f).ceil
    end

    def make_name_view(file_names)
      formatted_list = file_names.map { |name| name.ljust(columns_width(file_names)) }
      sliced_list = formatted_list.each_slice(number_of_rows(file_names)).to_a
      sliced_list.last << '' while sliced_list.last.size < number_of_rows(file_names)
      sliced_list.transpose.map(&:join)
    end
  end
end
