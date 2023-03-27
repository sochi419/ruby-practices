# frozen_string_literal: true

require './case_except_option_l'
require './case_option_l'
require 'optparse'

COLUMN = 3

option = ARGV.getopts('a', 'r', 'l')
files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files = files.reverse if option['r']

if option['l']
  CaseOptionL.new(files).output_file
else
  CaseExceptOptionL.new(files, COLUMN).output_file
end
