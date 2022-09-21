# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')

  if ARGV.empty?
    output(build_data_for_stdin, options)
  else
    total = { line: 0, word: 0, byte: 0, file: 'total' }
    ARGV.each do |file|
      calculate_result = build_data_for_file(file)
      total[:line] += calculate_result[:line]
      total[:word] += calculate_result[:word]
      total[:byte] += calculate_result[:byte]
      output(build_data_for_file(file), options)
    end
    output(total, options) if ARGV.size > 1
  end
end

def build_data_for_stdin
  combined_filename = $stdin.readlines.join
  build_data_for_text(combined_filename, '')
end

def build_data_for_file(file)
  str = File.read(file)
  build_data_for_text(str, file)
end

def build_data_for_text(str, file)
  { line: count_line(str), word: count_words(str), byte: count_byte(str), file: file }
end

def output(data, option)
  no_option = lack_option(option)
  print adjust_space(data[:line]) if option['l'] || no_option
  print adjust_space(data[:word]) if option['w'] || no_option
  print adjust_space(data[:byte]) if option['c'] || no_option

  print " #{data[:file]}"
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
