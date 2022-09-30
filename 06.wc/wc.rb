# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')

  if ARGV.empty?
    output(build_data_for_stdin, options)
  else
    total = { line: 0, word: 0, byte: 0, file: 'total' }
    ARGV.each do |file|
      line_word_byte = build_data_for_file(file)
      total[:line] += line_word_byte[:line]
      total[:word] += line_word_byte[:word]
      total[:byte] += line_word_byte[:byte]
      output(line_word_byte, options)
    end
    output(total, options) if ARGV.size > 1
  end
end

def build_data_for_stdin
  joined_stndard_inputs = $stdin.readlines.join

  build_data_for_text(joined_stndard_inputs, '')
end

def build_data_for_file(file)
  str = File.read(file)
  build_data_for_text(str, file)
end

def build_data_for_text(str, file)
  { line: count_line(str), word: count_words(str), byte: count_byte(str), file: file }
end

def output(data, option)
  no_option = (option == { 'l' => false, 'w' => false, 'c' => false })
  print adjust_space(data[:line]) if option['l'] || no_option
  print adjust_space(data[:word]) if option['w'] || no_option
  print adjust_space(data[:byte]) if option['c'] || no_option

  print " #{data[:file]}"
  puts
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
