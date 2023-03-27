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

    @files.each do |file|
      file_info = FileInfo.new(file)
      max_length = calculate_max_length(file, file_info)
      print file_info.type(file)
      print "#{file_info.permission(file)}  "
      print "#{file_info.hardlink(file).to_s.rjust(max_length[:hardlink])} "
      print "#{file_info.user(file).rjust(max_length[:user])}  "
      print "#{file_info.group(file).rjust(max_length[:group])}  "
      print "#{file_info.size(file).to_s.rjust(max_length[:filesize])}  "
      print "#{file_info.time(file)} "
      print file
      print "\n"
    end
  end

  private

  def output_blocks_total
    total = []
    files.map do |file|
      total << get_file_info(file).blocks
    end
    puts "total #{total.sum}"
  end

  def calculate_max_length(_file, file_info)
    hardlinks = []
    users = []
    groups = []
    filesizes = []

    files.each do |file|
      hardlinks << file_info.hardlink(file).to_s
      users << file_info.user(file)
      groups << file_info.group(file)
      filesizes << file_info.size(file).to_s
    end

    {
      hardlink: hardlinks.max_by(&:length).length,
      user: users.max_by(&:length).length,
      group: groups.max_by(&:length).length,
      filesize: filesizes.max_by(&:length).length
    }
  end

  def get_file_info(file)
    File.stat(file)
  end
end
