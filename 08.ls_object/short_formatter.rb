# frozen_string_literal: true

class ShortFormatter
  attr_reader :files, :column

  COLUMN = 3

  def initialize(files)
    @files = files
  end

  def output_file
    max_length = files.max_by(&:length).length

    sort_files(files, COLUMN).each do |lines|
      lines.each do |file|
        print format("%-#{max_length + 1}s", file)
      end
      puts
    end
  end
end

private

def sort_files(files, column)
  divided_directories = files.each_slice((files.size.to_f / column).ceil).to_a
  until divided_directories.first.size == divided_directories.last.size
    # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを末尾に追加する。
    divided_directories.last << nil
  end

  divided_directories.transpose
end
