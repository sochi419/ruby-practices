# frozen_string_literal: true

require './frame'

class Game
  attr_reader :each_frame_scores

  def initialize(scores)
    @each_frame_scores = Frame.new(scores)
  end

  def score
    each_frame_scores.score.sum
  end
end
