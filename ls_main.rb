# frozen_string_literal: true

require 'optparse'
require './ls_formatter.rb'

module Ls
  class Main
    def generate
      opt = OptionParser.new
      option = {}
      opt.on('-a') { |v| option[:all] = v }
      opt.on('-l') { |v| option[:list] = v }
      opt.on('-r') { |v| option[:reverse] = v }
      opt.parse!(ARGV)

      Formatter.new(option, ARGV).generate
    end
  end
end

Ls::Main.new.generate
