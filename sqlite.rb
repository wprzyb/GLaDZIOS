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

def handler(feedback)

	if feedback != nil								# If there is a SQLite3::Exception 
		puts feedback								# Debug: puts that exception
		if feedback =~ /^no such table*/			# If there is problem with missing table
			tablename = /^no such table: (.+)/		# Than catch name of that table
			return "notable_#{tablename}"			# And return it so i can assume if it's notable problem
		end
	end
	
end

def exe(file, query)
	
	begin
		database = SQLite3::Database.open file 		# Self explanatory
		database.execute(query)                     #
		puts "Executing that query"					# 
	rescue SQLite3::Exception => e 					# Exception catching
       	puts "Exception occured"					# 
    	puts e 										# Which exception is that
	ensure
		database.close if database
		puts "Database closed after executing"
	end

end

def sel(file, query)
	begin
		table = 0								#
		database = SQLite3::Database.open file 	#
		request = database.prepare(query)		#
		returned = request.execute 				#
		
		returned.each do |row| 					#
			row.join "\s"    					#
			table = row 						#
		end 									#

		return table 							# Problematic piece of code, Skrzyp help meh
		return handler(SQLite3::Exception) 		# Double return, mhm
	rescue SQLite3::Exception => e 				# But i tried to get exception outside rescue, and it didn't work well
		puts e 									# 
	ensure
		if request then request.close end
		if database then database.close end
	end
end

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


def check(file)
	begin
		if !File.exists?(file) then
			database = SQLite3::Database.new file
			puts "Database generated!"
		end

		database = SQLite3::Database.open file
		puts "Database opened!"
		query = sel(file, 'SELECT * FROM sqlite_master WHERE type = "table" ; ')
		puts query
		if query.kind_of?(Array) == true then 							# sel() should return an array, if it doesn't, it's exception return that i want to mess with
			puts "Checked for tables, it has them"						#
			puts "Here you are" + query.to_s							# 
		else															# There \/
				if query =~ /notable_memo/ then 
					puts "No memo table around, i should make it"
					memo_table_generate(file)
				end
				if query =~ /notable_seen/ then
					puts "No seen table around, i should make it"
					seen_table_generate(file)
				end
		end
  	

	ensure	
		database.close if database
		puts "Database closed!"
	end
end



def seen_check_user(who)
	base = "base.db"
	base_check = check(base)

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
#seen_table_generate("base.db")
check("base2.db")
#seen_check_user("Skrzyp")
