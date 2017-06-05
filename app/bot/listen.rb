require "facebook/messenger"
#
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])
#
# Bot.on :message do |message|
#   if message.text == 'score'
#     text =  get_latest_cricket_score
#   else
#     text = 'Please type SCORE to get one'
#   end
#   Bot.deliver({
#     recipient: message.sender,
#     message: {
#       # text: message.text
#       text: text
#     }
#   }, access_token: ENV['ACCESS_TOKEN'])
# end
#
def get_latest_cricket_score
  agent = Mechanize.new
  page = agent.get('http://www.cricbuzz.com/')
  page.search('.cb-ovr-flo').to_a.first.text
end
#
# def get_latest_match_score
#   api_url = 'http://cricapi.com/api/cricketScore'
#   parameters = {apikey: 'HKnBB5kEMNWbrw7X8Nt3l92nui72', unique_id: 1034809}
#
#   HTTParty.post( api_url,query: parameters)
# end

# Bot.on :message do |message|
#   begin
#     message.typing_on
#   rescue Exception => e
#     puts e.message
#     puts e.backtrace.join("\n")
#   end
# end

# Facebook::Messenger::Profile.set({
#   greeting: [
#     {
#       locale: 'default',
#       text: 'Welcome to your new bot CricCric!'
#     }
#   ]
# }, access_token: ENV['ACCESS_TOKEN'])

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  puts "#{message.messaging}"
  message.typing_on

  m_reply = message.text

  case m_reply
  when /hello/i || /hi/i
    message.reply(
      text: 'Hey there!',
      quick_replies: [
        {
          content_type: 'text',
          title: 'Live score',
          payload: 'SCORE'
        }
      ]
    )

  when /live score/i || /score/i
    teams = ["India", "Sri Lanka", "West Indies", "South Africa", "Pakistan"]
    response = HTTParty.get('http://cricscore-api.appspot.com/csa')
    results = response.select {|m| teams.include?(m['t1']) }.inject([]) {|arr,t| arr << [[t['t1'],t['t2']],t['id']]; arr }
    message.reply(
      text: 'Fetching score for you',
      quick_replies:
        results.inject([]) do |arr,t|
          arr << { content_type: 'text', title: t[0].join(' vs '), payload: "LIVE_SCORE/#{t[1]}" }
          arr
        end
    )

  when /something humans like/i
    message.reply(
      text: 'I found something humans seem to like:'
    )

    message.reply(
      attachment: {
        type: 'image',
        payload: {
          url: 'https://i.imgur.com/iMKrDQc.gif'
        }
      }
    )

    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Did human like it?',
          buttons: [
            { type: 'postback', title: 'Yes', payload: 'HUMAN_LIKED' },
            { type: 'postback', title: 'No', payload: 'HUMAN_DISLIKED' }
          ]
        }
      }
    )
  else
    if(message.messaging['message']['quick_reply'] != nil)
      if message.messaging['message']['quick_reply']['payload'].split('/')[0] == 'LIVE_SCORE'
       id = message.messaging['message']['quick_reply']['payload'].split('/')[1].to_i
       response = HTTParty.get("http://cricscore-api.appspot.com/csa?id=#{id}")
       message.reply(
         text: "#{response[0]['de']}"
       )
      else
       message.reply(
        text: 'Sorry no luck.'
       )
      end
    else
      message.reply(
        text: "Type score to get latest scores about recent matches. Don't forget to like page. :)"
      )
    end
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when 'HUMAN_LIKED'
    text = 'That makes bot happy!'
  when 'HUMAN_DISLIKED'
    text = 'Oh.'
  end

  postback.reply(
    text: text
  )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
  puts "See here: #{delivery}"
end
