# frozen_string_literal: true

require 'optparse'

class FileArrayization
  attr_reader :option

  def initialize(option)
    @option = option
  end

  def insert_files_in_array(option)
    files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files = files.reverse if option['r']

    files
  end
end
