# frozen_string_literal: true

class Ls
  def initialize
    @directory_elements = Dir.glob('*')
    if (@directory_elements.size % COLUMN).zero?
      divided_elements = @directory_elements.each_slice(@directory_elements.size / COLUMN).to_a
    else
      divided_elements = @directory_elements.each_slice(@directory_elements.size / COLUMN + 1).to_a
      until divided_elements.first.size == divided_elements.last.size
        # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを代入する。
        divided_elements.last << nil
      end
    end
    @divided_elements = divided_elements
  end

  def output
    sorted_elements = @divided_elements.transpose
    max_length = @directory_elements.max_by(&:length).length
    sorted_elements.each do |x|
      x.delete(nil)
      x.map { |n| n << (' ' * (max_length - n.length)).to_s }
      puts x.join(' ').to_s
    end
  end
end

COLUMN = 3
ls = Ls.new
ls.output
