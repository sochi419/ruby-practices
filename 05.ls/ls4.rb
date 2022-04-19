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

  def option_l
    @file_details = []
    @total = []

    @directories.each do |file|
      file_block_total(file)
      file_type(file)
      file_permission(file)
      file_hardlink(file)
      file_user(file)
      file_group(file)
      file_size(file)
      file_time(file)

      file_detail = [@type, @permission_integer, @hardlink, @user, @group, @filesize, @timestamp, file]
      @file_details << file_detail
    end

    space_adjustment

    puts "total #{@total.sum}"

    @file_details.each do |x|
      puts "#{x[0]}#{x[1]} #{x[2].rjust(@max_hardlink)} #{x[3].rjust(@max_user)} #{x[4].rjust(@max_group)} #{x[5].rjust(@max_filesize)} #{x[6]} #{x[7]}"
    end
  end

  def file_block_total(file)
    fs = File::Stat.new(file).blocks
    @total << fs
  end

  def file_type(file)
    case File.ftype(file)
    when 'file'
      @type = '-'
    when 'directory'
      @type = 'd'
    when 'socket'
      @type = 's'
    when 'link'
      @type = 'l'
    end
  end

  def file_permission(file)
    permission = File::Stat.new(file).mode.to_s(8).chars
    permission_rwx = [permission[-3], permission[-2], permission[-1]]
    integer_to_rwx = []
    permission_rwx.each do |y|
      case y
      when '7'
        integer_to_rwx.push('rwx')
      when '6'
        integer_to_rwx.push('rw-')
      when '5'
        integer_to_rwx.push('r-x')
      when '4'
        integer_to_rwx.push('r--')
      when '3'
        integer_to_rwx.push('-wx')
      when '2'
        integer_to_rwx.push('-w-')
      when '1'
        integer_to_rwx.push('--x')
      when '0'
        integer_to_rwx.push('---')
      end
    end
    @permission_integer = integer_to_rwx.join
  end

  def file_hardlink(file)
    @hardlink = File::Stat.new(file).nlink.to_s
  end

  def file_user(file)
    @user = Etc.getpwuid(File.stat(file).uid).name
  end

  def file_group(file)
    @group = Etc.getgrgid(File.stat(file).gid).name
  end

  def file_size(file)
    @filesize = File.size(file).to_s
  end

  def file_time(file)
    @timestamp = File.mtime(file).strftime('%m %d %H:%M')
  end

  def space_adjustment
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
  ls.option_l
else
  ls.sort_directories
end
