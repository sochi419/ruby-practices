# frozen_string_literal: true

require './file_read'
require './except_l'
require './directories_sort'
require './option_l'

opt = ARGV.getopts('a', 'r', 'l')
options = File_read.new(opt)
files = options.make_files_in_array(options.option)

if opt['l']
  d = OptionL.new(files)
  d.output_file(files)
else
  max_length = files.max_by(&:length).length
  sorted_dir = DirectoriesSort.new(files).sort_directories(files)
  ExceptOptionL.new(sorted_dir).output_file(sorted_dir, max_length)
end
