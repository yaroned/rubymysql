
require_relative 'WordCountParser_mysql'
# my_parser = WordCount.new()
# my_parser.countWordsDir("./books")

my_parser = WordCountParser_mysql.new("books/");

my_parser.form_dictionary()