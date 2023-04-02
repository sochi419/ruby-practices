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
    output_blocks_total
    max_length = calculate_max_length

    @file_infos.each do |file_info|
      print file_info.type
      print "#{file_info.permission}  "
      print "#{file_info.hardlink.to_s.rjust(max_length[:hardlink])} "
      print "#{file_info.user.rjust(max_length[:user])}  "
      print "#{file_info.group.rjust(max_length[:group])}  "
      print "#{file_info.size.to_s.rjust(max_length[:filesize])}  "
      print "#{file_info.time.strftime('%m %d %H:%M')} "
      print file_info.file
      print "\n"
    end
  end

  private

  def output_blocks_total
    blocks = @file_infos.sum(&:block)
    puts "total #{blocks}"
  end

  def calculate_max_length
    {
      hardlink: @file_infos.map { |file_info| file_info.hardlink.to_s.length }.max,
      user: @file_infos.map { |file_info| file_info.user.length }.max,
      group: @file_infos.map { |file_info| file_info.group.length }.max,
      filesize: @file_infos.map { |file_info| file_info.size.to_s.length }.max
    }
  end
end
