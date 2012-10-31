# encoding: UTF-8
#
#	sqlite.rb - SQLite module for GLaDZIOS - IRC bot for HSCracow
#
# (C) 2012 Jakub Skrzypnik
# (C) 2012 Wiktor Przybylski
#
# This program is licensed under GNU General Public License
#

#require 'cinch'
#require 'open-uri'
require 'sqlite3'

def check(file)

if !File.exists?(file)
	db = SQLite3::Database.new file
end

database = SQLite3::Database.open file
request = database.prepare("SELECT * FROM sqlite_master WHERE type = \"table\" ; ")
query = request.execute
if query != nil then return 1 end

database.close if database

end

def exe(file, query)
	database = SQLite3::Database.open file
	database.execute(query)
	database.close if database
end

def sel(file, query)
	database = SQLite::Database.open
	request = database.prepare(query)
	returned = request.execute
	returned.each do |row|
    puts row.join "\s"
	end
	return row
	database.close if database
end

##########################################################################################
#																						 #
#	Real magic begins thar. Since there it will be only bot command handling functions	 #
#	which are using sqlite All above is essential.										 #
#																						 #
##########################################################################################
																						 #
def seen_table_generate																	 #
	database = SQLite::Database.open													 #
#	database.execute "CREATE TABLE IF NOT EXISTS ..."									 #
	database.close if database															 #
end																						 #
																						 #
def seen_memo_generate																	 #
	database = SQLite::Database.open													 #
#	database.execute "CREATE TABLE IF NOT EXISTS ..."									 #
	database.close if database															 #
end																						 #
##########################################################################################
																						 #
																						 
