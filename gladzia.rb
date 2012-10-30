# encoding: UTF-8
#
# GLaDZIOS - IRC bot for HSCracow
#
# (C) 2012 Jakub Skrzypnik
# (C) 2012 Wiktor Przybylski
#
# This program is licensed under GNU General Public License
#

require 'cinch'
require 'open-uri'

def title(page)
  URI.parse(page).open do |f|
    f.each_line do |l|
      if l =~ /<title>\s*(.*)\s*<\/title>/iu
        return $1
      end
    end
  end
  nil
end

def cut(link)
	if link =~ /(.*)ujeb\.se(.*)/
	return "already shortened!"
	else
	return open('http://ujeb.se/a/add?u=' + link, "UserAgent" => "GLaDZIOS").read
	end
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
		version = "git-roll"
		m.reply "GLaDZIOS Hackerspace IRCbot. Version: #{version}"
		debug ":: [version] by #{m.user.nick}"
	end
	
	on :message, /^.8b/ do |m|
		replies = ['tak', 'nie', 'moze']
		m.reply "#{m.user.nick}: #{replies[rand(replies.length)]}"
		debug ":: [8b] by #{m.user.nick}"
	end

	on :message, /^.quit/ do |m|
		m.reply "Stopping GLaDZIOS..."
		gladzios.quit
	end
	
	on :message, /(https?:\/\/[\S]+)/ do |m, query|
			if tytul(query) != nil
				title = tytul(query)
			else 
				title = "Unknown"
			end
			
		m.reply "#{m.user.nick} posted a link to: #{title} - shorten URL: #{ciach(query)}"
	debug ":: [url] #{query} by #{m.user.nick}"
	end

end

puts 'Starting GLaDZIOS...'
gladzios.start
