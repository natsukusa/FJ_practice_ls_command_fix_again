# frozen_string_literal: true

require 'etc'

module Ls
  class FileData
    FILE_TYPE = {
      'blockSpecial' => 'b',
      'characterSpecial' => 'c',
      'directory' => 'd',
      'link' => 'l',
      'socket' => 's',
      'fifo' => 'p',
      'file' => '-'
    }.freeze

    PERMISSION = {
      '7' => 'rwx',
      '6' => 'rw-',
      '5' => 'r-x',
      '4' => 'r--',
      '3' => '-wx',
      '2' => '-w-',
      '1' => '--x',
      '0' => '---'
    }.freeze

    attr_accessor :file

    def initialize(file)
      @file = file
    end

    def format_max_nlink_digit(file_details, file_data)
      max_nlink_digit = file_details.map(&:nlink).max.to_s.length
      file_data.nlink.to_s.rjust(max_nlink_digit)
    end

    def format_max_size_digit(file_details, file_data)
      max_size_digit = file_details.map(&:size).max.to_s.length
      file_data.size.to_s.rjust(max_size_digit)
    end

    def ftype
      FILE_TYPE[File.ftype(@file)]
    end

    def mode
      permission = File.lstat(@file).mode.to_s(8)[-3..-1]
      change_mode_style(permission).join
    end

    def change_mode_style(permission)
      permission.each_char.map do |number|
        PERMISSION.fetch(number)
      end
    end

    def nlink
      File.lstat(@file).nlink
    end

    def owner
      Etc.getpwuid(File.lstat(@file).uid).name
    end

    def group
      Etc.getgrgid(File.lstat(@file).gid).name
    end

    def size
      File.lstat(@file).size
    end

    def mtime
      File.lstat(@file).mtime.strftime('%_m %_d %H:%M')
    end

    def blocks
      File.lstat(@file).blocks.to_i
    end
  end
end
