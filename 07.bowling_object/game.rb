require "./frame"

class Game
  attr_reader :first_frame, :second_frame, :third_frame, :fourth_frame, :fifth_frame, :sixth_frame, :seventh_frame, :eighth_frame, :ninth_frame, :tenth_frame

  def initialize(first_frame_score, second_frame_score, third_frame_score, fourth_frame_score, fifth_frame_score, sixth_frame_score, seventh_frame_score, eighth_frame_score, ninth_frame_score, tenth_frame_score)
    @first_frame = Frame.new(first_frame_score)
    @second_frame = Frame.new(second_frame_score)
    @third_frame = Frame.new(third_frame_score)
    @fourth_frame = Frame.new(fourth_frame_score)
    @fifth_frame = Frame.new(fifth_frame_score)
    @sixth_frame = Frame.new(sixth_frame_score)
    @seventh_frame = Frame.new(seventh_frame_score)
    @eighth_frame = Frame.new(eighth_frame_score)
    @ninth_frame = Frame.new(ninth_frame_score)
    @tenth_frame = Frame.new(tenth_frame_score)
  end

  def score
    first_frame.score + second_frame.score + third_frame.score + fourth_frame.score + fifth_frame.score + sixth_frame.score + seventh_frame.score + eighth_frame.score + ninth_frame.score + tenth_frame.score
  end
end
