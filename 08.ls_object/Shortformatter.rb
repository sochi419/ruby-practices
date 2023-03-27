# frozen_string_literal: true

class ShortFormatter
  attr_reader :files, :column

  def initialize(files, column)
    @files = files
    @column = column
  end

  def sort_files(files, column)
    if (files.size % column).zero?
      divided_directories = files.each_slice(files.size / column).to_a
    else
      divided_directories = files.each_slice(files.size / column + 1).to_a
      until divided_directories.first.size == divided_directories.last.size
        # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを末尾に追加する。
        divided_directories.last << nil
      end
    end
    divided_directories.transpose
  end

  def output_file
    max_length = files.max_by(&:length).length

    sort_files(files, column).each do |sort_directory|
      sort_directory.each do |directory|
        print format("%-#{max_length + 1}s", directory)
      end
      puts
    end
  end
end
