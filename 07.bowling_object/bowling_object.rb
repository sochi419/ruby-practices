# frozen_string_literal: true

require './game'

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

each_frame = shots.each_slice(2).to_a
if shots.size == 20 # 第10フレームが2投の場合
else # 第10フレームが3投の場合
  each_frame[9] = each_frame[9..].flatten
  each_frame.slice!(10, 11)
  each_frame[9].delete(0)
end

each_frame_score = []

each_frame.each_with_index do |shot, i|
  frame = Frame.new(shot[0].to_s, shot[1].to_s, shot[2].to_s)

  each_frame_score << if each_frame[i + 1].nil?
                        frame.score
                      elsif shot[0] == 10 && each_frame[i + 1][0] == 10 && each_frame[i + 2].nil?
                        frame.score + each_frame[i + 1][0] + + each_frame[i + 1][1]
                      elsif shot[0] == 10 && each_frame[i + 1][0] == 10
                        frame.score + each_frame[i + 1][0] + each_frame[i + 2][0]
                      elsif shot[0] == 10
                        frame.score + each_frame[i + 1][0] + each_frame[i + 1][1]
                      elsif frame.score == 10
                        frame.score + each_frame[i + 1][0]
                      else
                        frame.score
                      end
end

game = Game.new(each_frame_score[0], each_frame_score[1], each_frame_score[2], each_frame_score[3], each_frame_score[4], each_frame_score[5],
                each_frame_score[6], each_frame_score[7], each_frame_score[8], each_frame_score[9])
p game.score
