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

def check(file, type)

if !File.exists?(file)
	db = SQLite3::Database.new file
end

database = SQLite3::Database.open file
request = database.prepare("SELECT * FROM sqlite_master WHERE type="table";")
query = request.execute



tablice = Array.new

query.each do |tablice|
	puts tablice.join "\s"
	end



end
