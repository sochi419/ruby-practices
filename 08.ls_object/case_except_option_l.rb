# frozen_string_literal: true

class CaseExceptOptionL
  def output_file(sorted_dir, max_length)
    sorted_dir.each do |sort_directory|
      sort_directory.each do |directory|
        print format("%-#{max_length + 1}s", directory)
      end
      puts
    end
  end
end
