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
$LOAD_PATH << '.'
require 'sqlite.rb'

replies = ['Wszystko wskazuje na to, że tak','Tak','Mam wątpliwości, spytaj ponownie', 'Bez wątpienia', 'Moje źródła mówią, że nie','Sadze, ze raczej tak', 'Ręczę za to', 'Skoncentruj się, i zapytaj jeszcze raz','Perspektywy są raczej słabe','Zdecydowanie, definitywnie tak', 'Teraz lepiej nie mówić', 'Bardzo wątpliwe','Tak, zdecydowanie', 'Tak, to pewne', 'Nie moąna teraz tego przewidzieć', 'Bardzo prawdopodobne','Zadaj pytanie później', 'Odpowiedz brzmi: Nie.', 'Są ku temu dobre perspektywy','Nie licz na to']

def pagecheck(page)
begin
  open(page)
  puts 'ok'
  nil
rescue
  puts 'crap'
  return 404
end
end

def title(page)
if pagecheck(page) != 404 then
  URI.parse(page).open do |f|
  f.each_line do |l|
    if l =~ /<title>\s*(.*)\s*<\/title>/ then return $1
     end
    end
   end
  end
  nil
 end
 
def cut(link)
 if link.length <= 20 then return 'niczego, bo już jest krótki ;P' else
  if link =~ /(.*)ujeb\.se(.*)/ then return 'niczego, bo już był skrócony :)' else
   return open('http://ujeb.se/a/add?u=' + link, "UserAgent" => "GLaDZIOS").read
  end
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
  version = `git describe --always HEAD`
  m.reply "Bot ircowy dla Hackerspace Kraków. wersja: #{version}"
 end
 on :message, /^.8b (.+)/ do |m|
  m.reply "#{m.user.nick}: #{replies[rand(replies.length)]}"
 end
 on :message, /^.quit/ do |m|
  m.reply "GLaDZIOS idzie spać..."
  gladzios.quit
 end
 on :message, /^.dice(\s\d+)?/ do |m, query|
  if query == nil then query = 6 end
  m.reply "Rzut kostką dał: #{rand(query.to_i)+1}"
 end
 on :message, /^.pick (.+)/ do |m, q|
  picks = q.split(/ /)
   if picks.length > 1 then
    m.reply "Lepiej #{picks[rand(picks.length)]}"
   else m.reply "Spośród czego mam wybierać? ;D"
  end
 end
 on :message, /(https?:\/\/[\S]+)/ do |m, query|
  #puts title(query) #degub
  if pagecheck(query) == 0
   if title(query) then title = title(query).force_encoding('UTF-8') 
   else title = "(nieznany)"
   end
  m.reply "#{m.user.nick} dał linka do #{title}, a ja skróciłam go do #{cut(query)}"
  else
   m.reply "#{m.user.nick} dał mi martwy link (#{query}). Nie lubię martwych linków"
  end
 end

 on :message, /óje/ do |m, query|
	m.reply "#{m.user.nick}: uje sie nie kreskuje."
 end

end
gladzios.start
