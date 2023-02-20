require './file_read'
require './except_l'
require './directories_sort'
require './option_l'

opt = ARGV.getopts('a', 'r', 'l') # {"a"=>true, "r"=>false, "l"=>false}
options = File_read.new(opt) # <File_read:0x000000010b149860 @option={"a"=>true, "r"=>false, "l"=>false}>
files = File_read.new(opt).make_files_in_array(File_read.new(opt).option) # ["file_read.rb", "free.rb", "free2.rb", "free2.tb", "ls5.rb", "ls_a.rb", "ls_l.rb", "ls_r.rb"]

if opt['l']
    d = Option_l.new(files)
    d.output_file(files)
else
    max_length = files.max_by(&:length).length
    sorted_dir = Directories_sort.new(files).sort_directories(files)
    Except_l.new(sorted_dir).output_file(sorted_dir, max_length)
end
