# frozen_string_literal: true

class ShortFormatter
  COLUMN = 3

  def initialize(files)
    @files = files
  end

  def output_file
    max_length = @files.max_by(&:length).length

    divide_files_by_column(@files, COLUMN).each do |files|
      files.each do |file|
        print format("%-#{max_length + 1}s", file)
      end
      puts
    end
  end

  private

  def divide_files_by_column(files, column)
    number_of_directory_division = (files.size.to_f / column).ceil
    divided_directories = files.each_slice(number_of_directory_division).to_a

    difference_number_of_elements = divided_directories.first.size - divided_directories.last.size
    difference_number_of_elements.times do
      # 後述するtransposeメソッドを使うために、要素数が不足している配列に、nilを末尾に追加する。
      divided_directories.last << nil
    end

    divided_directories.transpose
  end
end
