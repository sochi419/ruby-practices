# frozen_string_literal: true

class Ls
  # 要素数が4以下の場合、formula1を適用する。
  def way1
    arr = Dir.glob('*')
    # 要素数m 列数nとする。
    m = arr.size
    # 出力位置を統一するため、変数max, empty1を定義
    max = arr.max_by(&:length).length
    empty1 = ' ' * (max - arr[0].length)
    case m
    when 1
      print (arr[0]).to_s
    when 2
      print "#{arr[0]} #{empty1} #{arr[1]}"
    when 3
      empty2 = ' ' * (max - arr[1].length)
      print "#{arr[0]} #{empty1} #{arr[1]} #{empty2} #{arr[2]}".rjust(max)
    else # m == 4 の場合
      print "#{arr[0]} #{empty1} #{arr[2]} #{empty2} #{arr[3]}".rjust(max)
      print "\n"
      print (arr[1]).to_s
      print "\n"
    end
  end

  # (要素数:m) % (列数:n) != 0の場合、formula2メソッドを適用する。
  def way2
    arr = Dir.glob('*')
    # 要素数m 列数nとする。
    m = arr.size
    n = 3

    # 1行目に出力される要素を、空配列lineに代入する。
    x = 1
    line = []
    while x <= n
      line << 1 + ((x - 1) * ((m / n) + 1))
      x += 1
    end

    arrays = []
    arrays << line
    # lineの各要素に1を足して、arraysに代入する。lineの要素が最終行の要素になるまで、処理を繰り返す。
    (m / n).times do
      line = line.map { |y| y + 1 }
      arrays << line
    end

    a = 0
    while a <= m / n
      # 出力位置調整のため、変数max, empty1, empty2を定義
      max = arr.max_by(&:length).length
      empty1 = ' ' * (max - arr[arrays[a][0] - 1].length)
      empty2 = ' ' * (max - arr[arrays[a][1] - 1].length)

      print "#{arr[arrays[a][0] - 1]} #{empty1} #{arr[arrays[a][1] - 1]} #{empty2} #{arr[arrays[a][2] - 1]}".rjust(max)
      print "\n"
      a += 1
    end
  end

  # (要素数:m) % (列数:n) == 0の場合、formula3メソッドを適用する。
  def way3
    arr = Dir.glob('*')
    # 要素数m 列数nとする。
    m = arr.size
    n = 3

    # 1行目に出力される要素を、空配列lineに代入する。
    line = []
    x = 1
    while x <= n
      line << (x - 1) * (m / n) + 1
      x += 1
    end

    arrays = []
    arrays << line
    # lineの各要素に1を足して、arraysに代入する。lineの要素が最終行の要素になるまで、処理を繰り返す。
    (m / n - 1).times do
      line = line.map { |y| y + 1 }
      arrays << line
    end

    a = 0
    while a <= m / n - 1
      # 出力位置調整のため、変数max, empty1, empty2を定義
      max = arr.max_by(&:length).length
      empty1 = ' ' * (max - arr[arrays[a][0] - 1].length)
      empty2 = ' ' * (max - arr[arrays[a][1] - 1].length)
      print "#{arr[arrays[a][0] - 1]} #{empty1} #{arr[arrays[a][1] - 1]} #{empty2} #{arr[arrays[a][2] - 1]}".rjust(max)
      print "\n"
      a += 1
    end
  end
end

ls = Ls.new
arr = Dir.glob('*')
# 列数nとする。
n = 3

if arr.size <= 4
  print ls.way1.to_s
elsif arr.size % n != 0
  print ls.way2.to_s
else
  print ls.way3.to_s
end
