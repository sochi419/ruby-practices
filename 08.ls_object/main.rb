# frozen_string_literal: true

require './LongFormatter'
require './ShortFormatter'
require 'optparse'

COLUMN = 3

option = ARGV.getopts('a', 'r', 'l')
files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files = files.reverse if option['r']

if option['l']
  LongFormatter.new(files).output_file
else
  ShortFormatter.new(files, COLUMN).output_file
end
