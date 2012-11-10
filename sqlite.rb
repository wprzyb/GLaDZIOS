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


require 'sqlite3'
require 'time' #i highly require some time...

class Sqlite

def exe(file, query)
 
 begin
  database = SQLite3::Database.open file  	# Self explanatory
  database.execute(query)					#
  puts "Executing that query"     			# 
 rescue SQLite3::Exception => e      		# Exception catching
        puts "Exception occured"     		# 
     puts e           						# Which exception is that
 ensure
  database.close if database
  puts "Database closed after executing"
 end

end

def sel(file, query)
 begin
  table = [] 
  database = SQLite3::Database.open file
  request = database.prepare(query) 
  returned = request.execute
  
  returned.each do |row|   
   row.join "\s"   
   table += row  
  end    
	puts "#{table} - 43"
  return table        					# Problematic piece of code, Skrzyp help meh
 rescue SQLite3::Exception => e     	# But i tried to get exception outside rescue, and it didn't work well
  puts "#{e} - line 61"
 ensure
  if request then request.close end
  if database then database.close end
 end
end

def memo_table_generate(file)
 database = SQLite3::Database.open file 
 database.execute "CREATE TABLE 'memo' ('id' int(11) PRIMARY KEY,'time' int(11) NOT NULL,'sender' varchar(10) NOT NULL,'receiver' varchar(10) NOT NULL,'memo' varchar(255) NOT NULL);"
 puts "Memo table generated!"
 #< if database then database.close puts "m-OK." end >#
end

def seen_table_generate(file)
 database = SQLite3::Database.open file
 database.execute "CREATE TABLE 'seen' ('who' varchar(10) NOT NULL,'time' int(11) NOT NULL,'content' varchar(255) NOT NULL);"
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
   #puts "line 93 - #{query}" # cuz it's only for debugging, i don't want crap in my log 
  if query.kind_of?(Array) == true then     	# sel() should return an array, if it doesn't, it's exception return that i want to mess with
   puts "Checked for tables, it has them"   	#
   return "OK" #cuz it's only for debugging, i don't want crap in my log "
   #puts "Here you are" + query.to_s # cuz it's only for debugging, i don't want crap in my log 
  else
    if query == 0 then
     puts "No tables, i will make both"
     memo_table_generate(file)
     seen_table_generate(file)
     return "GEN"
    end
    #if query =~ /notable_memo/ then 
    # puts "No memo table around, i should make it"
    # memo_table_generate(file)
    #end
    #if query =~ /notable_seen/ then
    # puts "No seen table around, i should make it"
    # seen_table_generate(file)
    #end
  end
   

 ensure 
  database.close if database
  puts "Database closed!"
 end
end



def seen_check_base(arg)
 base = "base.db"
 base_check = "WTF"
 until base_check == "OK" # until base check don't return that it's generated and working keep checking&generating it
  base_check = check(base)
  puts "Zwrocila #{base_check}" # and inform me about it
 end

ask = "SELECT * FROM seen WHERE who=\"#{arg}\""

checked = sel(base,ask)
return checked


end 

def seen_check(who)
 if seen_check_base(who) == 0 then return "Never seen before" 
 else 
  table = seen_check_base(who)
  return table  
 end
end

def seen_add(who,what,time)
 if seen_check_base(who) == 0
    query = "INSERT INTO seen VALUES (\"#{who}\", \"#{what}\", #{time})"
 else
    query = "UPDATE seen SET time=\"#{time}\", content=\"#{what}\" WHERE who=\"#{who}\""
 end

    exe("base.db", query)
end

end
