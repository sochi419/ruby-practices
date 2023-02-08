# frozen_string_literal: true

require './frame'

class Game
  attr_reader :frames

  def initialize(all_shot)
    @frames = build_frames(all_shot).map do |frame|
      Frame.new(frame[0], frame[1], frame[2].to_i)
    end
  end

  def build_frames(scores)
    shots = []
    scores.each do |s|
      shots << Shot.new(s).score
      shots << 0 if s == 'X'
    end
    each_frame = shots.each_slice(2).to_a

    if shots.size == 20 # 第10フレームが2投の場合
    else # 第10フレームが3投の場合
      each_frame[9] = each_frame[9..].flatten
      each_frame.slice!(10, 11)
      each_frame[9].delete(0)
    end
    each_frame
  end

  def score
    calculate_each_frame_score(frames)
  end

  def calculate_each_frame_score(frames)
    each_frame_scores = frames.map.with_index do |shot, i|
      sum = shot.score

      if last_frame?(frames, i)
        sum
      elsif shot.strike?
        sum + shot.point_of_strike(frames, i)
      elsif shot.spare?
        sum + shot.point_of_spare(frames, i)
      else
        sum
      end
    end
    each_frame_scores.sum
  end

  def last_frame?(frames, index)
    frames[index + 1].nil?
  end
end
