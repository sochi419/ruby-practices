# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')

  if ARGV.empty?
    output(build_data_for_stdin, options)
  else
    total = { line: 0, word: 0, byte: 0, file: 'total' }
    ARGV.each do |file|
      total[:line] += build_data_for_file(file)[:line].to_i
      total[:word] += build_data_for_file(file)[:word].to_i
      total[:byte] += build_data_for_file(file)[:byte].to_i
      output(build_data_for_file(file), options)
    end
    output(total, options) if ARGV.size > 1
  end
end

def build_data_for_stdin
  inputs = $stdin.readlines.join
  get_calculate_result(inputs, '')
end

def build_data_for_file(file)
  str = File.read(file)
  get_calculate_result(str, file)
end

def get_calculate_result(str, file)
  { line: count_line(str), word: count_words(str), byte: count_byte(str), file: file }
end

def output(data, option)
  print adjust_space(data[:line]) if option['l'] || lack_option(option)
  print adjust_space(data[:word]) if option['w'] || lack_option(option)
  print adjust_space(data[:byte]) if option['c'] || lack_option(option)

  print(' ')
  print data[:file]
  puts
end

def lack_option(option)
  !option['l'] && !option['w'] && !option['c']
end

def adjust_space(data)
  data.to_s.rjust(8, ' ')
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
