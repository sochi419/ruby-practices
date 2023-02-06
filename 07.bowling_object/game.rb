# frozen_string_literal: true

require './frame'

class Game
  attr_reader :scores

  def initialize(all_shot)
    @scores = all_shot
  end

  def score
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

    calculate_each_frame_score(each_frame)
  end

  def calculate_each_frame_score(each_frame_shots)
    each_frame_scores = each_frame_shots.map.with_index do |shot, i|
      frame = Frame.new(shot[0], shot[1], shot[2].to_i)
      sum = frame.score
      if last_frame?(each_frame_shots, i)
        sum
      elsif calculate_double_strike_after_nine_frame(each_frame_shots, shot, i) # 第9フレームでストライク且つ第10フレームもストライク
        sum + each_frame_shots[i + 1][0] + each_frame_shots[i + 1][1]
      elsif calculate_double_strike_until_eight_frame(each_frame_shots, shot, i) # 第8フレームまででストライク且つ次フレームもストライク
        sum + each_frame_shots[i + 1][0] + each_frame_shots[i + 2][0]
      elsif frame.strike?
        sum + each_frame_shots[i + 1][0] + each_frame_shots[i + 1][1]
      elsif frame.spare?
        sum + each_frame_shots[i + 1][0]
      else
        sum
      end
    end
    each_frame_scores.sum
  end

  def last_frame?(each_frame_shots, index)
    each_frame_shots[index + 1].nil?
  end

  def calculate_double_strike_after_nine_frame(each_frame_shots, shot, index)
    shot[0] == 10 && each_frame_shots[index + 1][0] == 10 && each_frame_shots[index + 2].nil?
  end

  def calculate_double_strike_until_eight_frame(each_frame_shots, shot, index)
    shot[0] == 10 && each_frame_shots[index + 1][0] == 10
  end
end
