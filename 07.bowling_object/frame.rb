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

  def point_of_strike(frames, index)
    if frames[index + 1].strike? && frames[index + 2].nil?
      frames[index + 1].first_shot.score + frames[index + 1].second_shot.score
    elsif frames[index + 1].strike?
      frames[index + 1].first_shot.score + frames[index + 2].first_shot.score
    else
      frames[index + 1].score
    end
  end

  def point_of_spare(frames, index)
    frames[index + 1].first_shot.score
  end
end
