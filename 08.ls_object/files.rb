# frozen_string_literal: true

require 'optparse'

class Files
  attr_reader :option

  def put_files_in_array(option)
    files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files = files.reverse if option['r']

    files
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
end
