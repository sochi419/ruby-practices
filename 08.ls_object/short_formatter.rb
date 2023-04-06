# frozen_string_literal: true

class ShortFormatter
  COLUMN = 3

  def initialize(files)
    @files = files
  end

  def output
    max_length = @files.max_by(&:length).length

    split_files_by_column.each do |files|
      files.each do |file|
        print format("%-#{max_length + 1}s", file)
      end
      puts
    end
  end

  private

  def split_files_by_column
    row_count = (@files.size.to_f / COLUMN).ceil
    divided_directories = @files.each_slice(row_count).to_a

    diff_count = divided_directories.first.size - divided_directories.last.size
    diff_count.times do
      # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを末尾に追加する。
      divided_directories.last << nil
    end

    divided_directories.transpose
  end
end
