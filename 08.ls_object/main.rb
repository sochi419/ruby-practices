# frozen_string_literal: true

require './arranging_order'
require './case_except_option_l'
require './case_option_l'
require 'optparse'

option = ARGV.getopts('a', 'r', 'l')
files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
files = files.reverse if option['r']

COLUMN = 3

if option['l']
  CaseOptionL.new(files).output_file
else
  max_length = files.max_by(&:length).length
  CaseExceptOptionL.new(ArrangingOrder.new(files, COLUMN).sort_files, max_length).output_file
end
