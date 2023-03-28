# frozen_string_literal: true

require './long_formatter'
require './short_formatter'
require 'optparse'

option = ARGV.getopts('a', 'r', 'l')
files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files = files.reverse if option['r']

if option['l']
  LongFormatter.new(files).output_file
else
  ShortFormatter.new(files).output_file
end
