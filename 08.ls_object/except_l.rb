# filesを与えれば、file一覧を返してくれるクラス

# require './directories_sort'

class Except_l
    attr_reader :files
    def initialize(files)
      @files = files
    end
  
    def output_file(a, max_length)
    

        a.each do |sort_directory|
          sort_directory.each do |directory|
            print format("%-#{max_length + 1}s", directory)
          end
          puts
        end
    end
  end
