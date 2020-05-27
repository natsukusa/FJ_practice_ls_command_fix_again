# frozen_string_literal: true

require 'optparse'
require './ls_formatter.rb'

module Ls
  class Main
    def generate(option, argv)
      Formatter.new(option, argv).generate
    end
  end

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
