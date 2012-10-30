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
    f.each_line do |l|
      if l =~ /<title>\s*(.*)\s*<\/title>/iu
        return $1
      end
    end
  end
  nil
end

def ciach(link)
	if link =~ /(.*)ujeb\.se(.*)/
	return "... zaraz zaraz, co ty mi tu dajesz ?"
	else
	return open('http://ujeb.se/a/add?u=' + link, "UserAgent" => "Ruby Script").read
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
			if tytul(query) != nil
				title = tytul(query)
			else 
				title = "coś czego nie znam"
			end
			
		m.reply "#{m.user.nick} wysłał: #{title} - skróciłam\: #{ciach(query)}"
	end

end

puts 'Starting GLaDZIOS...'
gladzios.start
