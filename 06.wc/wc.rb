# frozen_string_literal: true

require 'optparse'

def main
  opt = ARGV.getopts('l', 'w', 'c')

  if ARGV.empty?
    datas = build_data_for_stdin
    output_stdin(opt, datas)
  else
    ARGV.each do |file|
      datas = build_data_for_argv(opt, file)
      output_argv(opt, datas, file)
    end
    output_total(opt, ARGV)
  end
end

def build_data_for_stdin
  inputs = $stdin.readlines
  word_count = 0
  bytesize = 0
  inputs.each do |input|
    word_count += input.split(/\s+/).size
    bytesize += input.bytesize
  end
  [inputs.size, word_count, bytesize]
end

def output_stdin(opt, datas)
  if !opt['l'] && !opt['w'] && !opt['c']
    datas.each do |data|
      output(data)
    end
  end
  output(datas[0]) if opt['l']
  output(datas[1]) if opt['w']
  output(datas[2]) if opt['c']
end

def output(result)
  print result.to_s.rjust(8, ' ')
end

def build_data_for_argv(opt, argument)
  str = File.read(argument)
  output = if !opt['l'] && !opt['w'] && !opt['c']
             [count_line(str), count_words(str), count_byte(argument)]
           else
             []
           end

  output << count_line(str) if opt['l']
  output << count_words(str) if opt['w']
  output << count_byte(argument) if opt['c']

  output
end

def output_argv(_opt, datas, file)
  datas.each do |data|
    output(data)
  end

  print(' ')
  print file
  puts
end

def build_data_for_total(opt, files)
  total_lines_words_bytes = []

  files.each do |file|
    total_lines_words_bytes << build_data_for_argv(opt, file) # 後述のtransposeメソッドを使うために、二重配列にした。
  end
  total_lines_words_bytes.transpose.map(&:sum)
end

def output_total(opt, files)
  return if files[1].nil?

  build_data_for_total(opt, ARGV).each do |total|
    output(total)
  end
  print(' ')
  print 'total'
end

def count_line(file)
  file.lines.count
end

def count_words(file)
  file.split(/\s+/).size
end

def count_byte(file)
  File.size(file)
end

main
