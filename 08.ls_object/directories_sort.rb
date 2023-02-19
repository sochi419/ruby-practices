# filesを与えれば、中身の配置を整えるクラス

class Directories_sort
    attr_reader :option
    def initialize(files)
      @files = files
    end
  
    def sort_directories(files)
        column = 3
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

#   files = ["file_read.rb", "free.rb", "free2.rb", "free2.tb", "ls5.rb", "ls_a.rb", "ls_l.rb", "ls_r.rb"]
# a = Directories_sort.new(files) 
# # p a.sort_directories(files) 

# transposeなし → [["file_read.rb", "free.rb", "free2.rb"], ["free2.tb", "ls5.rb", "ls_a.rb"], ["ls_l.rb", "ls_r.rb", nil]]
# transposeあり → [["file_read.rb", "free2.tb", "ls_l.rb"], ["free.rb", "ls5.rb", "ls_r.rb"], ["free2.rb", "ls_a.rb", nil]]