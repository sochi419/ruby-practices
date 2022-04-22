# frozen_string_literal: true

require 'optparse'
require 'etc'

class Ls
  COLUMN = 3
  def initialize
    opt = ARGV.getopts('a', 'r', 'l')
    @directories = if opt['a']
                     Dir.glob('*', File::FNM_DOTMATCH)
                   elsif opt['r']
                     Dir.glob('*').reverse
                   else
                     Dir.glob('*')
                   end
  end

  def divide_directories
    if (@directories.size % COLUMN).zero?
      divide_directories = @directories.each_slice(@directories.size / COLUMN).to_a
    else
      divide_directories = @directories.each_slice(@directories.size / COLUMN + 1).to_a
      until divide_directories.first.size == divide_directories.last.size
        # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを代入する。
        divide_directories.last << nil
      end
    end
    divide_directories
  end

  def sort_directories
    sorted_directories = divide_directories.transpose
    max_length = @directories.max_by(&:length).length
    sorted_directories.each do |x|
      x.each do |y|
        print format("%-#{max_length + 1}s", y)
      end
      puts
    end
  end

  def run_option_l
    @file_details = []
    @total = []

    @directories.each do |file|
      get_total(file)
      get_type(file)
      get_permission(file)
      get_hardlink(file)
      get_user(file)
      get_group(file)
      get_size(file)
      get_time(file)

      file_detail = [@type, @permission_rwx, @hardlink, @user, @group, @filesize, @timestamp, file]
      @file_details << file_detail
    end

    adjust_space

    puts "total #{@total.sum}"

    @file_details.each do |x|
      puts "#{x[0]}#{x[1]} #{x[2].rjust(@max_hardlink)} #{x[3].rjust(@max_user)} #{x[4].rjust(@max_group)} #{x[5].rjust(@max_filesize)} #{x[6]} #{x[7]}"
    end
  end

  def get_total(file)
    fs = File::Stat.new(file).blocks
    @total << fs
  end

  def get_type(file)
    @type = File.ftype(file)
    @type = {
      'file' => '-',
      'directory' => 'd',
      'link' => 'l',
      'socket' => 's'
    }[@type]
  end

  def get_permission(file)
    permission = File::Stat.new(file).mode.to_s(8).chars
    permission_integer = [permission[-3], permission[-2], permission[-1]]
    permission_rwx = permission_integer.map do |y|
      {
        '7' => 'rwx',
        '6' => 'rw-',
        '5' => 'r-x',
        '4' => 'r--',
        '3' => '-wx',
        '2' => '-w-',
        '1' => '--x',
        '0' => '---'
      }[y]
    end
    @permission_rwx = permission_rwx.join
  end

  def get_hardlink(file)
    @hardlink = File::Stat.new(file).nlink.to_s
  end

  def get_user(file)
    @user = Etc.getpwuid(File.stat(file).uid).name
  end

  def get_group(file)
    @group = Etc.getgrgid(File.stat(file).gid).name
  end

  def get_size(file)
    @filesize = File.size(file).to_s
  end

  def get_time(file)
    @timestamp = File.mtime(file).strftime('%m %d %H:%M')
  end

  def adjust_space
    i = 0
    @hardlinks = []
    @users = []
    @groups = []
    @filesizes = []

    until i == @file_details.length
      @hardlinks << @file_details[i][2]
      @users << @file_details[i][3]
      @groups << @file_details[i][4]
      @filesizes << @file_details[i][5]
      i += 1
    end

    @max_hardlink = @hardlinks.max_by(&:length).length
    @max_user = @users.max_by(&:length).length
    @max_group = @groups.max_by(&:length).length
    @max_filesize = @filesizes.max_by(&:length).length
  end
end

opt = ARGV.getopts('a', 'r', 'l')
ls = Ls.new
if opt['l']
  ls.run_option_l
else
  ls.sort_directories
end
