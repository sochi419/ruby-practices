# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN = 3

def main
  opt = ARGV.getopts('a', 'r', 'l')
  files = if opt['a']
            Dir.glob('*', File::FNM_DOTMATCH)
          elsif opt['r']
            Dir.glob('*').reverse
          else
            Dir.glob('*')
          end

  if opt['l']
    output_blocks_total(files)

    files.each do |file|
      output_option_l(file, files)
    end
  else
    output_except_option_l(files)
  end
end

def divide_directories(files)
  if (files.size % COLUMN).zero?
    divided_directories = files.each_slice(files.size / COLUMN).to_a
  else
    divided_directories = files.each_slice(files.size / COLUMN + 1).to_a
    until divided_directories.first.size == divided_directories.last.size
      # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを代入する。
      divided_directories.last << nil
    end
  end
  divided_directories
end

def sort_directories(files)
  divide_directories(files).transpose
end

def output_except_option_l(files)
  max_length = files.max_by(&:length).length
  sort_directories(files).each do |sort_directory|
    sort_directory.each do |directory|
      print format("%-#{max_length + 1}s", directory)
    end
    puts
  end
end

def output_option_l(file, files)
  max_length = calculate_max_length(files)

  type = get_type(file)
  permission = get_permission(file)
  hardlink = get_hardlink(file).rjust(max_length[:hardlink])
  user = get_user(file).rjust(max_length[:user])
  group = get_group(file).rjust(max_length[:group])
  size = get_size(file).rjust(max_length[:filesize])
  time = get_time(file)
  filename = file

  puts "#{type}#{permission} #{hardlink} #{user} #{group} #{size} #{time} #{filename}"
end

def calculate_max_length(files)
  hardlinks = []
  users = []
  groups = []
  filesizes = []

  files.each do |file|
    hardlinks << get_hardlink(file)
    users << get_user(file)
    groups << get_group(file)
    filesizes << get_size(file)
  end

  {
    hardlink: hardlinks.max_by(&:length).length,
    user: users.max_by(&:length).length,
    group: groups.max_by(&:length).length,
    filesize: filesizes.max_by(&:length).length
  }
end

def output_blocks_total(files)
  total = []
  files.map do |file|
    total << get_file_info(file).blocks
  end
  puts "total #{total.sum}"
end

def get_file_info(file)
  File.stat(file)
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
  permission = get_file_info(file).mode.to_s(8).chars
  permission_integer = [permission[-3], permission[-2], permission[-1]]
  permission_rwx = permission_integer.map do |number|
    {
      '7' => 'rwx',
      '6' => 'rw-',
      '5' => 'r-x',
      '4' => 'r--',
      '3' => '-wx',
      '2' => '-w-',
      '1' => '--x',
      '0' => '---'
    }[number]
  end
  permission_rwx.join
end

def get_hardlink(file)
  get_file_info(file).nlink.to_s
end

def get_user(file)
  Etc.getpwuid(get_file_info(file).uid).name
end

def get_group(file)
  Etc.getgrgid(get_file_info(file).gid).name
end

def get_size(file)
  File.size(file).to_s
end

def get_time(file)
  File.mtime(file).strftime('%m %d %H:%M')
end

main
