# encoding: UTF-8
#
#	sqlite.rb - SQLite module for GLaDZIOS - IRC bot for HSCracow
#
#
# (C) 2012 Wiktor Przybylski
# (C) 2012 Jakub Skrzypnik
#
# This program is licensed under GNU General Public License
#

# ProTip(tm) - Jak robisz większy kod, to dawaj komentarze, do cholery!

#require 'cinch'
#require 'open-uri'
require 'sqlite3'

def exe(file, query)
	database = SQLite3::Database.open file
	database.execute(query)
	database.close if database
end

def sel(file, query)
	table = 0
	database = SQLite3::Database.open file
	request = database.prepare(query)
	returned = request.execute
	returned.each do |row|
		row.join "\s"
		table = row
	end
	return table	
	if request then request.close end
	if database then database.close end
end

def check(file)
	if !File.exists?(file) then
		database = SQLite3::Database.new file
		puts "Database generated!"
	end
	database = SQLite3::Database.open file
	puts "Database opened!"
	query = sel(file, 'SELECT * FROM sqlite_master WHERE type = "table" ; ')
	puts "Evaluated #{query.to_s} query!"
	if query != nil then return 1 else return nil end
	database.close if database
	puts "Database closed!"
end

##	Real magic begins thar. Since there it will be 
##	only bot command handling functions
##	which are using sqlite. All above is essential.

def memo_table_generate(file)
	database = SQLite3::Database.open file	
	database.execute "CREATE TABLE 'memo' ('id' int(11) NOT NULL,'time' int(11) NOT NULL,'sender' varchar(10) NOT NULL,'receiver' varchar(10) NOT NULL,'memo' varchar(255) NOT NULL, PRIMARY KEY ('id'));"
	puts "Memo table generated!"
	#< if database then database.close puts "m-OK." end >#
end

def seen_table_generate(file)
	database = SQLite3::Database.open file
	database.execute "CREATE TABLE 'seen' ('id' int(11) NOT NULL,'time' int(11) NOT NULL,'who' varchar(10) NOT NULL,'content' varchar(255) NOT NULL, PRIMARY KEY ('id'));"
	puts "Seen table generated!"
	#< if database then database.close puts "s-OK." end >#
end

def seen_check_user(who)
	base = "base.db"
	base_check = check(base)
	if (base_check.to_s == nil) then seen_table_generate(base) end
	checkuser = sel(base, "SELECT * FROM seen WHERE who=#{who}")
	if checkuser != nil then return 1 else return nil end
end	

def seen_check(who)
	if seen_check_user(who) == nil then return "Never seen before" end
end

##
## def seen_add(who, what, where)
## end
##
## def memo_check(who, where)
## end
##
## def memo_add(who, what, where)
## end	

# seen_table_generate("base.db")
# sel("base.db", 'SELECT * FROM sqlite_master WHERE type = "table" ; ')
# seen_table_generate("base2.db")
seen_check_user("Skrzyp")
