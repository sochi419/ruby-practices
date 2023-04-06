# frozen_string_literal: true

class FileInfo
  FILE_TYPE = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  FILE_PERMISSION = {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x',
    '0' => '---'
  }.freeze

  attr_reader :file

  def initialize(file)
    @file = file
    @file_stat = File.stat(file)
  end

  def type
    FILE_TYPE[@file_stat.ftype]
  end

  def permission
    file_permissions = @file_stat.mode.to_s(8).chars
    file_permissions[-3..-1].map { |number| FILE_PERMISSION[number] }.join
  end

  def hardlink
    @file_stat.nlink
  end

  def user
    Etc.getpwuid(@file_stat.uid).name
  end

  def group
    Etc.getgrgid(@file_stat.gid).name
  end

  def size
    @file_stat.size
  end

  def time
    @file_stat.mtime
  end

  def block
    @file_stat.blocks
  end
end
