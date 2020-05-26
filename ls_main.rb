# frozen_string_literal: true

require 'optparse'
require './ls_detail_list_formatter.rb'
require './ls_name_list_formatter.rb'

module Ls
  class Main
    def generate(option, argv)
      if option[:list]
        DetailListFormatter.new(option, argv).generate
      else
        NameListFormatter.new(option, argv).generate
      end
    end

    private

  #   def argv_exist_(argv)
  #     argv.each do |value|
  #       if File.file?(value)
  #         raise puts "#{value}: No such file"
  #       else File.directory?(value)
  #         raise puts "#{value}: No such directory"
  #       end
  #     end
  #   end
  # end

  if $PROGRAM_NAME == __FILE__
    opt = OptionParser.new

    option = {}

    opt.on('-a') { |v| option[:all] = v }
    opt.on('-l') { |v| option[:list] = v }
    opt.on('-r') { |v| option[:reverse] = v }

    opt.parse!(ARGV)

    Main.new.generate(option, ARGV)
  end
end
