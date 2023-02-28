# frozen_string_literal: true

require './files'
require './case_except_option_l'
require './case_option_l'

option = ARGV.getopts('a', 'r', 'l')

COLUMN = 3

if option['l']
  CaseOptionL.new.output_file(Files.new.put_files_in_array(option))
else
  max_length = Files.new.put_files_in_array(option).max_by(&:length).length
  CaseExceptOptionL.new.output_file(Files.new.sort_files(Files.new.put_files_in_array(option), COLUMN), max_length)
end
