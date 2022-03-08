# frozen_string_literal: true

class Ls
  COLUMN = 3
  def initialize
    @directories = Dir.glob('*')
  end

  def divided_directories
    if (@directories.size % COLUMN).zero?
      divided_directories = @directories.each_slice(@directories.size / COLUMN).to_a
    else
      divided_directories = @directories.each_slice(@directories.size / COLUMN + 1).to_a
      until divided_directories.first.size == divided_directories.last.size
        # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを代入する。
        divided_directories.last << nil
      end
    end
    @divided_directories = divided_directories
  end

  def output
    divided_directories
    sorted_directories = @divided_directories.transpose
    max_length = @directories.max_by(&:length).length
    sorted_directories.each do |x|
      x.delete(nil)
      x.map { |n| n << (' ' * (max_length - n.length)).to_s }
      puts x.join(' ').to_s
    end
  end
end

ls = Ls.new
ls.output
