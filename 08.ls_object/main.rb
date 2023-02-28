# frozen_string_literal: true

require './file_arrayization'
require './case_except_option_l'
require './file_align'
require './case_option_l'

option = ARGV.getopts('a', 'r', 'l')
files = FileArrayization.new(option).insert_files_in_array(option)

COLUMN = 3

if option['l']
  CaseOptionL.new(files).output_file(files)
else
  max_length = files.max_by(&:length).length
  CaseExceptOptionL.new.output_file(FileAlign.new(files).align_directories(files, COLUMN), max_length)
end
