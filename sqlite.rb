# encoding: UTF-8
#
#	sqlite.rb - SQLite module for GLaDZIOS - IRC bot for HSCracow
#
#
# (C) 2012 Wiktor Przybylski
#
# This program is licensed under GNU General Public License
#

#require 'cinch'
#require 'open-uri'
require 'sqlite3'

def check(file)

if !File.exists?(file)
	database = SQLite3::Database.new file
end

database = SQLite3::Database.open file
request = database.prepare('SELECT * FROM sqlite_master WHERE type = "table" ; ')
query = request.execute
if query != nil then return 1 else return nil end

database.close if database

end

def exe(file, query)
	database = SQLite3::Database.open file
	database.execute(query)
	database.close if database
end

def sel(file, query)
	database = SQLite3::Database.open file
	request = database.prepare(query)
	returned = request.execute
	returned.each do |row|
    puts row.join "\s"
	end
	return row
	database.close if database
end

#########################################################
#														#
#	Real magic begins thar. Since there it will be 		#
#	only bot command handling functions	 				#
#	which are using sqlite. All above is essential.  	#
#														#
#########################################################
														#
def memo_table_generate(file)							#
	database = SQLite3::Database.open file				#
	database.execute "CREATE TABLE IF NOT EXISTS `memo` (`id` int(11) NOT NULL,'time` int(11) NOT NULL,`sender` varchar(10) NOT NULL,`receiver` varchar(10) NOT NULL,`memo` varchar(255) NOT NULL, PRIMARY KEY (`id`);"
	database.close if database							#
end														#
														#
def seen_table_generate(file)							#
	database = SQLite3::Database.open file				#
	database.execute "CREATE TABLE IF NOT EXISTS `seen` (`id` int(11) NOT NULL,'time` int(11) NOT NULL,`who` varchar(10) NOT NULL,`content` varchar(255) NOT NULL, PRIMARY KEY (`id`);"
	database.close if database							#
end														#
#########################################################
														#
def seen_check_user(who, where)

	if check(where) == nil then seen_table_generate(where) end
	checked = sel(where, "SELECT * FROM seen WHERE who=#{who}")
	if checked != nil then return 1 else return nil end

end	

def seen_check(who, where)

	if seen_check_user(who, where) == nil then return "Never seen before"
	end

end

=begin

def seen_add(who, what, where)



end

def memo_check(who, where)



end

def memo_add(who, what, where)



end	

=end
													 
seen_check_user("skrzyp", "file.db")
