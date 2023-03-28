# frozen_string_literal: true

require 'etc'
require './file_info'

class LongFormatter
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def output_file
    ls_files = files.map do |ls_file|
      FileInfo.new(ls_file)
    end

    output_blocks_total(ls_files)

    ls_files.each do |ls_file|
      file_name = ls_file.name
      max_length = calculate_max_length(ls_file)

      print ls_file.type(file_name)
      print "#{ls_file.permission}  "
      print "#{ls_file.hardlink.to_s.rjust(max_length[:hardlink])} "
      print "#{ls_file.user.rjust(max_length[:user])}  "
      print "#{ls_file.group.rjust(max_length[:group])}  "
      print "#{ls_file.size(file_name).to_s.rjust(max_length[:filesize])}  "
      print "#{ls_file.time(file_name)} "
      print file_name
      print "\n"
    end
  end

  private

  def output_blocks_total(ls_files)
    blocks = ls_files.sum(&:block)
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
