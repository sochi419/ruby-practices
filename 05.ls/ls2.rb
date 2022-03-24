# frozen_string_literal: true

require 'optparse'

class Ls
  COLUMN = 3
  def initialize
    opt = ARGV.getopts('a')
    @directories = Dir.glob('*')
    @directories = Dir.glob('*', File::FNM_DOTMATCH) if opt['a']
  end

  def divide_directories
    if (@directories.size % COLUMN).zero?
      divide_directories = @directories.each_slice(@directories.size / COLUMN).to_a
    else
      divide_directories = @directories.each_slice(@directories.size / COLUMN + 1).to_a
      until divide_directories.first.size == divide_directories.last.size
        # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを代入する。
        divide_directories.last << nil
      end
    end
    divide_directories
  end

  def sort_directories
    sorted_directories = divide_directories.transpose
    max_length = @directories.max_by(&:length).length
    sorted_directories.each do |x|
      x.delete(nil)
      x.map { |n| n << (' ' * (max_length - n.length)).to_s }
      puts x.join(' ').to_s
    end
  end
end

ls = Ls.new
ls.sort_directories
