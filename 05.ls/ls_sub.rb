# frozen_string_literal: true

class Ls
  def instance
    @elements = Dir.glob('*')
    @column = 3
  end

  def make_arr
    instance
    if (@elements.size % @column).zero?
      frames = @elements.each_slice(@elements.size / @column).to_a
    else
      frames = @elements.each_slice(@elements.size / @column + 1).to_a
      frames.last << nil until frames.first.size == frames.last.size
    end
    @frames = frames
  end

  def output
    make_arr
    reverse = @frames.transpose
    reverse.each do |x|
      x.delete(nil)
      x.map { |n| n << (' ' * (@elements.max_by(&:length).length - n.length)).to_s }
      print "#{x.join(' ')}\n"
    end
  end
end

ls = Ls.new
ls.output
