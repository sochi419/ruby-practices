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
    total = []

    @directories.map! do |file|
      total << get_blocks(file)
      { type: get_type(file), permission: get_permission(file), hardlink: get_hardlink(file), user: get_user(file), group: get_group(file), size: get_size(file),
        time: get_time(file), filename: file }
    end

    puts "total #{total.sum}"

    @directories.each do |f|
      puts "#{f[:type]}#{f[:permission]} #{f[:hardlink].rjust(calculate_space[0])} #{f[:user].rjust(calculate_space[1])} #{f[:group].rjust(calculate_space[2])} #{f[:size].rjust(calculate_space[3])} #{f[:time]} #{f[:filename]}"
    end
  end

  def get_blocks(file)
    File::Stat.new(file).blocks
  end

  def get_type(file)
    type = File.ftype(file)
    {
      'file' => '-',
      'directory' => 'd',
      'link' => 'l',
      'socket' => 's'
    }[type]
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
    permission_rwx.join
  end

  def get_hardlink(file)
    File::Stat.new(file).nlink.to_s
  end

  def get_user(file)
    Etc.getpwuid(File.stat(file).uid).name
  end

  def get_group(file)
    Etc.getgrgid(File.stat(file).gid).name
  end

  def get_size(file)
    File.size(file).to_s
  end

  def get_time(file)
    File.mtime(file).strftime('%m %d %H:%M')
  end

  def calculate_space
    hardlinks = []
    users = []
    groups = []
    filesizes = []

    @directories.each do |directory|
      hardlinks << directory[:hardlink]
      users << directory[:user]
      groups << directory[:group]
      filesizes << directory[:size]
    end

    [hardlinks.max_by(&:length).length, users.max_by(&:length).length, groups.max_by(&:length).length, filesizes.max_by(&:length).length]
  end
end

opt = ARGV.getopts('a', 'r', 'l')
ls = Ls.new
if opt['l']
  ls.run_option_l
else
  ls.sort_directories
end
