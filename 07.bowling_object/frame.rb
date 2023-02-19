require "./shot"

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    first_shot.score + second_shot.score + third_shot.score
  end

  def strike?
    first_shot.score == 10
  end

  def spare?
    score == 10
  end

  def point_of_strike(next_frame, next_next_fame, index)
    if next_frame.strike? && next_next_fame.nil?
      next_frame.first_shot.score + next_frame.second_shot.score
    elsif next_frame.strike?
      next_frame.first_shot.score + next_next_fame.first_shot.score
    else
      next_frame.score
    end
  end

  def point_of_spare(next_frame, index)
    next_frame.first_shot.score
  end
end
