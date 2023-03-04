# frozen_string_literal: true

class CaseExceptOptionL
  attr_reader :sorted_dir, :max_length

  def initialize(sorted_dir, max_length)
    @sorted_dir = sorted_dir
    @max_length = max_length
  end

  def output_file
    sorted_dir.each do |sort_directory|
      sort_directory.each do |directory|
        print format("%-#{max_length + 1}s", directory)
      end
      puts
    end
  end
end
