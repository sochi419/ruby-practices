# frozen_string_literal: true

require 'etc'
require './file_info'

class CaseOptionL
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def output_file
    output_blocks_total

    files.each do |file|
      file_info = FileInfo.new(file)
      max_length = calculate_max_length(file_info)
      print file_info.type(file)
      print "#{file_info.permission}  "
      print "#{file_info.hardlink.to_s.rjust(max_length[:hardlink])} "
      print "#{file_info.user.rjust(max_length[:user])}  "
      print "#{file_info.group.rjust(max_length[:group])}  "
      print "#{file_info.size(file).to_s.rjust(max_length[:filesize])}  "
      print "#{file_info.time(file)} "
      print file
      print "\n"
    end
  end

  private

  def output_blocks_total
    blocks = files.sum do |file|
      file_info = FileInfo.new(file)
      file_info.block
    end
    puts "total #{blocks}"
  end

  def calculate_max_length(file_info)
    {
      hardlink: files.map { |_file| file_info.hardlink.to_s.length }.max,
      user: files.map { |_file| file_info.user.length }.max,
      group: files.map { |_file| file_info.group.length }.max,
      filesize: files.map { |file| file_info.size(file).to_s.length }.max
    }
  end
end
