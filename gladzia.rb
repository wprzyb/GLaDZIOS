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
replies = ['Wszystko wskazuje na to, że tak','Tak','Mam wątpliwości, spytaj ponownie', 'Bez wątpienia',	'Moje źródła mówią, że nie','Sadze, ze raczej tak', 'Ręczę za to', 'Skoncentruj się, i zapytaj jeszcze raz','Perspektywy są raczej słabe','Zdecydowanie, definitywnie tak', 'Teraz lepiej nie mówić', 'Bardzo wątpliwe','Tak, zdecydowanie', 'Tak, to pewne', 'Nie moąna teraz tego przewidzieć', 'Bardzo prawdopodobne','Zadaj pytanie później', 'Odpowiedz brzmi: Nie.', 'Są ku temu dobre perspektywy','Nie licz na to']
def title(page)
  URI.parse(page).open do |f|
	 f.each_line do |l| if l =~ /<title>\s*(.*)\s*<\/title>/ then return $1 end end
  end
  nil
end
def cut(link)
	if link =~ /(.*)ujeb\.se(.*)/ then return 'niczego, bo już był skrócony :)' else
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
	end
	on :message, '.version' do |m|
		version = system('git describe --always HEAD')
		m.reply "Bot ircowy dla Hackerspace Kraków. wersja: #{version}"
	end
	on :message, /^.8b (.+)/ do |m|
		m.reply "#{m.user.nick}: #{replies[rand(replies.length)]}"
	end
	on :message, /^.quit/ do |m|
		m.reply "GLaDZIOS idzie spać..."
		gladzios.quit
	end
		on :message, /^.dice (.+)/ do |m, query|
		if query == nil then query = 6 end
		m.reply "Rzut kostką dał: #{rand(query.to_i)+1}"
	end
		on :message, /^.pick (.+) (.+)/ do |m, q1, q2|
		picks = [q1, q2]
		m.reply "Lepiej #{picks[rand(picks.length)]}"
	end
	on :message, /(https?:\/\/[\S]+)/ do |m, query|
		if title(query) != nil then title = title(query) else title = "(nieznany)" end
		m.reply "#{m.user.nick} dał linka do #{title}, a ja skróciłam go do #{cut(query)}"
	end

end
gladzios.start
