# frozen_string_literal: true

require './ls_directory.rb'
require './ls_file_data.rb'

module Ls
  class DetailListFormatter
    def generate
      views = []
      views << Directory.new(Argv.files).generate_at_argv_files if Argv.files?
      views << generate_with_argv_directories if Argv.directories?
      views << Directory.new(Dir.pwd).generate_with_directories if Argv.both_empty?
      puts views
    end

    def generate_with_argv_directories
      views = []
      directories = sort_and_reverse(Argv.directories)
      directories.each do |directory|
        views << "\n" unless views.empty? && Argv.files.empty?
        views << "#{directory}:" if need_directory_name?
        views << Directory.new(directory).generate_with_directories
      end
      views
    end

    def need_directory_name?
      (Argv.files.length + Argv.directories.length) > 1
    end

    def sort_and_reverse(array)
      Argv.option[:reverse] ? array.sort.reverse : array.sort
    end
  end
end
