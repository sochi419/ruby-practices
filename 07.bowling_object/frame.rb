# frozen_string_literal: true

require './shot'

class Frame
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

    calculate_strike_or_spare(each_frame)
  end

  def calculate_strike_or_spare(each_frame_shots)
    each_frame_shots.map.with_index do |shot, i|
      sum = shot[0] + shot[1] + shot[2].to_i
      if each_frame_shots[i + 1].nil? # 最終フレーム
        sum
      elsif shot[0] == 10 && each_frame_shots[i + 1][0] == 10 && each_frame_shots[i + 2].nil? # 第9フレームストライク且つ第10フレームもストライク
        sum + each_frame_shots[i + 1][0] + each_frame[i + 1][1]
      elsif shot[0] == 10 && each_frame_shots[i + 1][0] == 10 # 第8フレームまででストライク且つ次フレームもストライク
        sum + each_frame_shots[i + 1][0] + each_frame_shots[i + 2][0]
      elsif shot[0] == 10 # ストライク
        sum + each_frame_shots[i + 1][0] + each_frame_shots[i + 1][1]
      elsif sum == 10 # スペア
        sum + each_frame_shots[i + 1][0]
      else # ストライクでもスペアでもないとき
        sum
      end
    end
  end
end
