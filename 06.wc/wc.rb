# frozen_string_literal: true

require 'optparse'

def main
  opt = ARGV.getopts('l', 'w', 'c')

  if ARGV.empty?
    data_stdin = build_data_for_stdin
    output(opt, data_stdin, nil, nil)
  else
    ARGV.each do |file|
      data_argv = build_data_for_argv(file)
      output(opt, data_argv, file, nil)
    end
    data_total = build_data_for_total(ARGV)
    output(opt, data_total, nil, ARGV.size) if ARGV.size > 1
  end
end

def build_data_for_stdin
  inputs = $stdin.readlines

  { line: count_line(inputs.join), word: count_words(inputs.join), byte: count_byte(inputs.join) }
end

def build_data_for_argv(file)
  str = File.read(file)

  { line: count_line(str), word: count_words(str), byte: count_byte(str) }
end

def build_data_for_total(files)
  count_line_total = 0
  count_word_total = 0
  count_byte_total = 0

  files.each do |file|
    str = File.read(file)
    count_line_total += count_line(str)
    count_word_total += count_words(str)
    count_byte_total += count_byte(str)
  end
  { line: count_line_total, word: count_word_total, byte: count_byte_total }
end

def output(opt, data, file, total_number_of_argv)
  output_calculate_result(data, opt)
  output_filename_or_total(file, total_number_of_argv)
end

def output_calculate_result(data, opt)
  if !opt['l'] && !opt['w'] && !opt['c']
    print data[:line].to_s.rjust(8, ' ')
    print data[:word].to_s.rjust(8, ' ')
    print data[:byte].to_s.rjust(8, ' ')
  else
    print data[:line].to_s.rjust(8, ' ') if opt['l']
    print data[:word].to_s.rjust(8, ' ') if opt['w']
    print data[:byte].to_s.rjust(8, ' ') if opt['c']
  end
end

def output_filename_or_total(file, total_number_of_argv)
  if ARGV.empty?
    puts
    return
  elsif total_number_of_argv == ARGV.size
    print(' ')
    print 'total'
  else
    print(' ')
    print file
  end

  puts
end

def count_line(file)
  file.lines.count
end

def count_words(file)
  file.split(/\s+/).size
end

def count_byte(file)
  file.bytesize
end

main
