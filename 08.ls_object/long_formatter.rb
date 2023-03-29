# frozen_string_literal: true

require 'etc'
require './file_info'

class LongFormatter

  def initialize(files)
    @file_infos = files.map do |file|
      FileInfo.new(file)
    end
  end

  def output_file
    output_blocks_total(@file_infos)
    max_length = calculate_max_length(@file_infos)

    @file_infos.each do |file_info|
      file_name = file_info.name

      print file_info.type(file_name)
      print "#{file_info.permission}  "
      print "#{file_info.hardlink.to_s.rjust(max_length[:hardlink])} "
      print "#{file_info.user.rjust(max_length[:user])}  "
      print "#{file_info.group.rjust(max_length[:group])}  "
      print "#{file_info.size(file_name).to_s.rjust(max_length[:filesize])}  "
      print "#{file_info.time(file_name).strftime('%m %d %H:%M')} "
      print file_name
      print "\n"
    end
  end

  private

  def output_blocks_total(file_infos)
    blocks = file_infos.sum(&:block)
    puts "total #{blocks}"
  end

  def calculate_max_length(file_infos)
    {
      hardlink: file_infos.map { |file_info| file_info.hardlink.to_s.length }.max,
      user: file_infos.map { |file_info| file_info.user.length }.max,
      group: file_infos.map { |file_info| file_info.group.length }.max,
      filesize: file_infos.map { |file_info| file_info.size(file_info.name).to_s.length }.max
    }
  end
end
