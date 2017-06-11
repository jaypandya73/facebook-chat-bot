require "facebook/messenger"
require_relative 'persistent_menu'
require_relative 'greeting'
require_relative 'talk_to_cricket_score_api'
#
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])
# https://bot-facebook-test.herokuapp.com/bot
PersistentMenu.enable
Greeting.enable
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
# def get_latest_cricket_score
#   agent = Mechanize.new
#   page = agent.get('http://www.cricbuzz.com/')
#   page.search('.cb-ovr-flo').to_a.first.text
# end
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

# Postback logic

Bot.on :postback do |postback|
  puts "I am in postback #{postback}"
  share = false
  case postback.payload
  when 'HUMAN_LIKED'
    text = 'That makes bot happy!'
  when 'HUMAN_DISLIKED'
    text = 'Oh.'
  when 'SQUARE_IMAGES'
    text = 'Okay getting it...'
    # message_options = {
    #   recipient: { id: postback.sender['id'] },
    #   message: { text: text }
    # }
    # Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  when 'START'
    text = "Welcome to CricCric! Instead of waiting for website to load the score, ask me and I will fetch you the score. If you like me don't forget to share it with your cricket fans :)"
  when 'CONTACT_INFO_PAYLOAD'
    text = "Contact to Jay. Email: jayved128@gmail.com"
  when 'SHARE_AND_INVITE'
    share = true
    message_options = {
      recipient: { id: postback.sender['id'] },
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'generic',
            image_aspect_ratio: 'horizontal',
            elements: [{
              title: 'CricCric bot image',
              image_url: 'https://cdn.pixabay.com/photo/2014/04/02/16/19/ball-306904_960_720.png',
              subtitle: "CricCric",
              buttons: [
                {
                  type: :element_share
                }
              ]
            }]
          }
        }
      }
     }
    Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  end

  unless share
    postback.reply(
      text: text
    )
  end
end

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"
  puts "#{message.messaging}"
  message.typing_on
  m_reply = message.text
  case m_reply

  # when /image/i
  #   message.reply(
  #     attachment: {
  #       type: 'template',
  #       payload: {
  #           template_type: 'generic',
  #           image_aspect_ratio: 'horizontal',
  #           elements: [{
  #             title: 'Random image',
  #             image_url: 'https://unsplash.it/760/400?random',
  #             subtitle: "Cricbuzz",
  #             default_action: {
  #               type: 'web_url',
  #               url: 'https://cricbuzz.com'
  #             },
  #             buttons: [
  #               {
  #                 type: :web_url,
  #                 url: 'https://cricbuzz.com',
  #                 title: 'CricBuzz'
  #               },
  #               {
  #                 type: :postback,
  #                 title: 'Square Images',
  #                 payload: 'SQUARE_IMAGES'
  #               }
  #             ]
  #           }]
  #         }
  #     }
  #   )

  when /invite/i, /share/i
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          image_aspect_ratio: 'horizontal',
          elements: [{
            title: 'CricCric bot image',
            image_url: 'https://cdn.pixabay.com/photo/2014/04/02/16/19/ball-306904_960_720.png',
            subtitle: "CricCric",
            buttons: [
              {
                type: :element_share
              }
            ]
          }]
        }
      }
    )

  when /hello/i, /hi/i
    message.reply(
      text: "Hey there!\nWant live score?",
      quick_replies: [
        {
          content_type: 'text',
          title: 'Live score',
          payload: 'SCORE'
        }
      ]
    )

  when /score/i
    show_matches_if_any(message.sender['id'])

  when /show me gif for fun/i
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
      #  response = HTTParty.get("http://cricscore-api.appspot.com/csa?id=#{id}")
      response = TalkToCricketScoreApi.post(id)
       message.reply(
        #  text: "#{response[0]['de']}"
        text: "#{response['score']}\n\nMatch Status: #{response['innings-requirement']}"
       )
      else
       message.reply(
        text: 'Sorry no luck.'
       )
      end
    else
      message.reply(
        text: "Sorry did't get you. Click on live score button to get latest score updates.",
        quick_replies: [
          {
            content_type: 'text',
            title: 'Live score',
            payload: 'SCORE'
          }
        ]
      )
    end
  end
end

def show_matches_if_any(recipient_id)
  teams = TalkToCricketScoreApi::ALLOWED_TEAMS
  response = TalkToCricketScoreApi.fetch_team_lists_with_unq_id
  results = response.select {|m| teams.include?(m['t1'])}.inject([]) {|arr,t| arr << [[t['t1'],t['t2']],t['id']]; arr }
  quick_replies = ''
  if results.blank?
    text = 'Sorry currently no live match is going on.'
  else
    text = 'Please choose team to see live score:'
    quick_replies = results.inject([]) do |arr,t|
      arr << { content_type: 'text', title: t[0].join(' vs '), payload: "LIVE_SCORE/#{t[1]}" }
      arr
    end
  end
  message_options = {
    recipient: { id: recipient_id },
    message: { text: text }
    }
  if quick_replies.present?
    message_options[:message][:quick_replies] = quick_replies
  end
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end



Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
  puts "See here: #{delivery}"
end
