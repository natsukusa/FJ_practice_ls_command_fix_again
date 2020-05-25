# frozen_string_literal: true

require 'io/console/size'

module Ls
  class NameListFormatter

    def generate
      views = []
      views << make_name_view(sort_and_reverse(Argv.files)) if Argv.files?
      views << generate_with_argv_directories if Argv.directories?
      views << make_name_view(sort_and_reverse(look_up_dir)) if Argv.both_empty?
      puts views
    end

    def generate_with_argv_directories
      views = []
      directories ||= sort_and_reverse(Argv.directories)
      directories.each do |directory|
        views << "\n" unless views.empty? && Argv.files.empty?
        views << "#{directory}:" if need_directory_name?
        file_names = Dir.chdir(directory) { sort_and_reverse(look_up_dir) }
        views << show_name(file_names)
      end
      views
    end

    def need_directory_name?
      (Argv.files.length + Argv.directories.length) > 1
    end

    def sort_and_reverse(array)
      Argv.option[:reverse] ? array.sort.reverse : array.sort
    end

    def look_up_dir
      Argv.option[:all] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    end

    def console_width
      IO.console_size[1]
    end

    # @columns_width = 8, 16, 24, 32, 40, 48 ...
    def columns_width(array)
      max_file_length = array.max_by(&:length).length
      ((max_file_length + 1) / 8.0).ceil * 8
    end

    def number_of_rows(array)
      number_of_columns = console_width / columns_width(array)
      (array.size / number_of_columns.to_f).ceil
    end

    def make_name_view(array)
      formatted_list = array.map { |name| name.ljust(columns_width(array)) }
      sliced_list = formatted_list.each_slice(number_of_rows(array)).to_a
      sliced_list.last << '' while sliced_list.last.size < number_of_rows(array)
      sliced_list.transpose.map(&:join)
    end
  end
end
