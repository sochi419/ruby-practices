# frozen_string_literal: true

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

frames = shots.each_slice(2).to_a

point = 0

# 第8フレームまでの得点を計算する
frames.each_with_index do |frame, i|
  frame_point = frame.sum
  # 以下のif文でstrike,spare,その他の場合の得点
  point += if frame[0] == 10 # strikeの場合
             if frames[i + 1][0] == 10 # 現在のフレームがストライク且つ、次フレームもストライクの場合
               10 + frames[i + 1][0] + frames[i + 2][0] # 10点 + 次フレームの1投目(ストライク)の得点 + 次の次のフレームの1投目の得点
             else
               10 + frames[i + 1][0] + frames[i + 1][1] # 10点 + 次フレームの1投目 + 次フレームの2投目
             end
           elsif frame_point == 10 # spareの場合
             10 + frames[i + 1][0]
           else
             frame_point # strikeでもspareでもない場合
           end

  break if i == 7 # 8投目の得点計算が完了したら、breakする。
end

# 第9フレームの得点を計算する
point += if frames[8][0] == 10 && frames[9][0] == 10 # 第9フレーム1投目がストライク且つ,第10フレームの1投目がストライクの場合
           10 + frames[9][0] + frames[10][0] # 10 + 第10フレームの1投目（ストライク） + 第10フレームの2投目
         elsif frames[8][0] == 10 && frames[9][0] != 10 # 第9フレームがストライク且つ、第10フレーム1投目がストライクではない場合
           10 + frames[9][0] + frames[9][1] # 10 + 第10フレームの1投目(ストライク以外) + 第10フレームの2投目
         elsif frames[8].sum == 10 # 第9フレームがスペアの場合
           10 + frames[9][0] # 10 + 第10フレーム1投目
         else
           frames[8].sum # その他の場合、第9フレームの1投目 + 第9フレームの2投目
         end

# 第10フレームの得点を計算する
point += if frames[9][0] == 10 && frames[10][0] == 10 # 第10フレームで,2連続ストライクの場合、3投目の得点を加算する
           frames[9].sum + frames[10].sum + frames[11].sum # 第10フレーム1投目(ストライク) + 2投目(ストライク) + 3投目
         elsif frames[9][0] == 10 || frames[9].sum == 10 # 第10フレームで、2投目でスペアになった場合、３投目の得点を加算する
           frames[9].sum + frames[10].sum # 第10フレーム1投目(ストライク以外) + 2投目(スペア) + 3投目
         else
           frames[9].sum # その他の場合、第10フレームの1投目 + 2投目
         end

puts point
