# frozen_string_literal: true

# filesを与えれば、file一覧を返してくれるクラス

require 'etc'

class OptionL
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def output_file(files)
    output_blocks_total(files)
    max_length = calculate_max_length(files)

    files.each do |file|
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
  end

  def get_file_info(file)
    File.stat(file)
  end

  def output_blocks_total(files)
    total = []
    files.map do |file|
      total << get_file_info(file).blocks
    end
    puts "total #{total.sum}"
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
end
