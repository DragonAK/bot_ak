require 'discordrb'
require 'net/http'
require 'active_support'
require 'active_support/core_ext'

bot = Discordrb::Bot.new token: 'NDA0MTg3NjA4MzUzMjEwMzY5.DhUxFg.Ymrp13obKbYMoVbDsTRIxZDpR0w'


def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  if res.kind_of?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
  else
    res.code[0] != "4" #false if http code starts with 4 - error on your side.
  end
rescue Errno::ENOENT
  false #false if can't find the server
end

@gituser = ''

bot.message(start_with:'!user ') do |event|
	x = event.content.to_s
	y = x.length
	@gituser = x[6..y]
	event.respond "Your user is set and ready to go! :D"
end




bot.message(start_with:'!git ') do |event|
	x = event.content.to_s
	y = x.length
	z = 'http://github.com/'+@gituser+'/'+x[5..y]
	if @gituser == ''
		event.respond "Please set your git user, LOL."
    else
  if url_exist?(z.to_s)
  	event.respond z
  else
    event.respond "Sorry LOL, this page does not exist... YET. >:)"	
  end
end
end

bot.message(start_with:'!raw ') do |event|
	x = event.content.to_s
	y = x.length
	z = x[5..y]
    
end

bot.run

