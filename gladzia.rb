# encoding: UTF-8
#
# GLaDZIOS - IRC bot for HSCracow
#
#	Wejq & Skrzyp
#
require 'cinch'
require 'open-uri'

def tytul(strona)
	URI.parse(strona).open do |f|
		f.each {|l| if md = (/<title>\s*(.*)\s*<\/title>/iu).match(l) then return md[1] end }
	end
	if md[1] == nil then return "Chuj" end
end

def ciach(link)
	return open('http://ujeb.se/a/add?u=' + link, "UserAgent" => "Ruby Script").read
end


gladzios = Cinch::Bot.new do
	configure do |c|
		c.server = 'irc.freenode.org'
		c.channels = ['#gladz-szpachlowa']
		c.nick = 'GLaDZIOS'
		c.realname = "Gladzislawa Szpachlowska"
		c.reconnect = true
		c.port = 6667
		c.user = 'GLaDZIOS'
	end
	
	on :message, '.ping' do |m|
		m.reply "#{m.user.nick}: pong"
		debug ":: [ping] by #{m.user.nick}"
	end

	on :message, '.version' do |m|
		version = "devtest2"
		m.reply "GLaDZIOS Hackerspace IRCbot. Version: #{version}"
		debug ":: [version] by #{m.user.nick}"
	end
	
	on :message, /^.8b/ do |m|
		replies = ['tak', 'nie', 'moze']
		m.reply "#{m.user.nick}: #{replies[rand(replies.length)]}"
		debug ":: [8b] by #{m.user.nick}"
	end

	on :message, /^.quit/ do |m|
		m.reply "Goodbye!"
		gladzios.quit
	end
	
	on :message, /(https?:\/\/[\S]+)/ do |m, query|
		m.reply "#{m.user.nick} wysłał: #{tytul(query)} - skróciłam\: #{ciach(query)}"
	end

end

puts 'Starting GLaDZIOS...'
gladzios.start
