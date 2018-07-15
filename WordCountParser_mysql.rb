# WordCountParser - the constructor accepts a directory path contains .txt files and form a word-count dictionary
# num_of_books - the number of .txt files in the directory
# names - array consists of the .txt files names in the directory

require "mysql2"
class WordCountParser_mysql

  def initialize(dir_path)
    @num_of_books = 0
    @names = Array.new
    @dir_path = dir_path
    @table_name = '__counts'
    @connection = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qb5rmuV3", :database => "mydb")
  rescue Mysql2::Error => e
    puts e.errno
    puts e.error
  end


  def form_dictionary()
    Dir.foreach(@dir_path){|file|
      next if file == '.' or file == '..'
      @names << file
      @num_of_books +=1
    }
    @names.each { |x| index_one(x) }
  end



  private

  #this code corresponded with db that its primary key is 'word' as its saved in the db
  # Indexes a file to the dicationary (in this case: book)
  # Params:
  # +book_name+:: .txt file path in the directory path
  def index_one(book_name)

    file = File.open( @dir_path+book_name, "r")

    puts "Indexing #{book_name}"
    file.each_line do |line|
      words = line.split
      words.each do |word|
        #word = word.gsub(/[^a-zA-Z0-9-]+/i, "").downcase
        word = word.gsub(/[;.""...,()?!*]+/i, "").downcase
        @connection.query("INSERT INTO #{@table_name} (word, count) VALUES ('#{@connection.escape(word)}', 1) ON DUPLICATE KEY UPDATE count=count+1")

      end
    end

    puts "Indexed #{book_name}"
  end



  #this commented code corresponded with db that its primary key is _id (int)
=begin
  # Indexes a file to the dicationary (in this case: book)
  # Params:
  # +book_name+:: .txt file path in the directory path
  def index_one(book_name)

    file = File.open( @dir_path+book_name, "r")

    puts "Indexing #{book_name}"
    file.each_line do |line|
      words = line.split
      words.each do |word|
        #word = word.gsub(/[^a-zA-Z0-9-]+/i, "").downcase
        word = word.gsub(/[;.""...,()?!*]+/i, "").downcase
        # puts("INSERT INTO #{@table_name} (word, count) VALUES ('#{(word)}', 1) ON DUPLICATE KEY UPDATE count=count+1")


        # check if value exists in mysql table:
        # booli = @connection.query("select exists(select * from #{@table_name} where word = #{@connection.escape(word)}))");
        # puts("SELECT EXISTS(SELECT * FROM #{@table_name} WHERE word='the')")
        booli = @connection.query("SELECT EXISTS(SELECT * FROM #{@table_name} WHERE word='#{@connection.escape(word)}') as x")
        res = booli.each{|x| x.values}
        puts (word + " " +res[0]["x"].to_s)
        flag = (res[0]["x"]) == 1 ? true : false
        if flag
          # make update
          @connection.query("update #{@table_name} set count=count+1 where word = '#{@connection.escape(word)}'")
        else
          # insert new
          @connection.query("INSERT INTO #{@table_name} (word, count) VALUES ('#{@connection.escape(word)}', 1) ON DUPLICATE KEY UPDATE count=count+1")

        end
      end
    end

    puts "Indexed #{book_name}"
  end


=end



end

