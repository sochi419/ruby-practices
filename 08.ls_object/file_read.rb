# オプションを与えれば、filesを返してくれるクラス

require 'optparse'

class File_read
  attr_reader :option
  def initialize(option)
    @option = option
  end

  def make_files_in_array(option)
    files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files = files.reverse if option['r']

    return files
  end
end

# opt = ARGV.getopts('a', 'r', 'l') # {"a"=>true, "r"=>false, "l"=>false}
# options = File_read.new(opt) # <File_read:0x000000010b149860 @option={"a"=>true, "r"=>false, "l"=>false}>
# p options.make_files(options.option) # ["file_read.rb", "free.rb", "free2.rb", "free2.tb", "ls5.rb", "ls_a.rb", "ls_l.rb", "ls_r.rb"]



