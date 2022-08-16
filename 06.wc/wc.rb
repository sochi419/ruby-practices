# frozen_string_literal: true

require 'optparse'

def main
  opt = ARGV.getopts('l', 'w', 'c')
  if ARGV.size.zero?
    use_stdin(opt) # コマンドに引数が与えられなかった場合。
  else
    use_argv(opt) # コマンドに引数が与えられた場合。
  end
end

# コマンドに引数が与えられなかった場合。
def use_stdin(opt)
  inputs = $stdin.readlines
  word_number = 0
  bytesize = 0
  inputs.each do |input|
    word_number += input.split(' ').size # 単語数を計算
    bytesize += input.bytesize # バイト数を計算
  end
  output_stdin(opt, inputs, word_number, bytesize)
end

def output_stdin(opt, inputs, word_number, bytesize)
  if (opt['l'] == false && opt['w'] == false && opt['c'] == false) || (opt['l'] == true && opt['w'] == true && opt['c'] == true)
    p inputs.size # 行数
    p word_number # 単語数
    p bytesize # バイト数
  else
    output_stdin_option(opt, inputs, bytesize)
  end
end

def output_stdin_option(opt, inputs, bytesize)
  p inputs.size if opt['l'] == true
  p inputs.size if opt['w'] == true
  p bytesize if opt['c'] == true
end

# コマンドに引数が与えられた場合。
def use_argv(opt)
  lines_words_bytes = []
  total_lines_words_bytes = []
  n = 0

  until n == (ARGV.size) # コマンドライン引数の数だけ、ループをさせる。
    output_argv(opt, ARGV[n], lines_words_bytes)
    puts output_argv(opt, ARGV[n], lines_words_bytes)

    total_lines_words_bytes << output_argv(opt, ARGV[n], lines_words_bytes) # 次行のtransposeメソッドを使うために、二重配列にした。
    total = total_lines_words_bytes.transpose.map(&:sum)
    puts lines_words_bytes

    puts ARGV[n]
    n += 1
  end

  return if ARGV[1].nil? # 引数が2つ以上の場合は、total値を表示する。

  puts total
  puts 'total'
end

def output_argv(opt, argument, _output)
  str = File.read(argument)

  if (opt['l'] == false && opt['w'] == false && opt['c'] == false) || (opt['l'] == true && opt['w'] == true && opt['c'] == true)
    [count_line(str), count_words(str), count_byte(argument)]
  else
    output_argv_option(opt, str, argument)
  end
end

def output_argv_option(opt, str, argument)
  output = []
  output << count_line(str) if opt['l'] == true
  output << count_words(str) if opt['w'] == true
  output << count_byte(argument) if opt['c'] == true
  output
end

def count_line(file)
  file.lines.count
end

def count_words(file)
  ary = file.split(/\s+/)
  ary.size
end

def count_byte(file)
  File.size(file)
end

main
