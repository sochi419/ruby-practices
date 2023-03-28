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

  def name
    @file
  end

  def type(file)
    type = File.ftype(file)
    FILE_TYPE[type]
  end

  def permission
    permission = @file_stat.mode.to_s(8).chars
    permission_integer = [permission[-3], permission[-2], permission[-1]]
    permission_rwx = permission_integer.map do |number|
      FILE_PERMISSION[number]
    end
    permission_rwx.join
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

  def size(file)
    File.size(file)
  end

  def time(file)
    File.mtime(file).strftime('%m %d %H:%M')
  end

  def block
    @file_stat.blocks
  end
end
