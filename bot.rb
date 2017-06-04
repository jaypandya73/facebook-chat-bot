# require 'facebook/messenger'
#
# include Facebook::Messenger
#
# Bot.on :message do |message|
#   message.id      # => 'mid.1457764197618:41d102a3e1ae206a38'
#   message.sender  # => { 'id' => '1008372609250235' }
#   message.seq     # => 73
#   message.sent_at # => 2016-04-22 21:30:36 +0200
#   message.text    # => 'Hello, bot!'
#
#   Bot.deliver(
#     recipient: message.sender,
#     message: {
#       text: 'Hello, human!'
#     }
#   )
# end

# require 'facebook/messenger'
#
# include Facebook::Messenger
#
# Bot.on :message do |message|
#   puts "Received '#{message.inspect}' from #{message.sender}"
#
#   case message.text
#   when /hello/i
#     message.reply(
#       text: 'Hello, human!',
#       quick_replies: [
#         {
#           content_type: 'text',
#           title: 'Hello, bot!',
#           payload: 'HELLO_BOT'
#         }
#       ]
#     )
#   when /something humans like/i
#     message.reply(
#       text: 'I found something humans seem to like:'
#     )
#
#     message.reply(
#       attachment: {
#         type: 'image',
#         payload: {
#           url: 'https://i.imgur.com/iMKrDQc.gif'
#         }
#       }
#     )
#
#     message.reply(
#       attachment: {
#         type: 'template',
#         payload: {
#           template_type: 'button',
#           text: 'Did human like it?',
#           buttons: [
#             { type: 'postback', title: 'Yes', payload: 'HUMAN_LIKED' },
#             { type: 'postback', title: 'No', payload: 'HUMAN_DISLIKED' }
#           ]
#         }
#       }
#     )
#   else
#     message.reply(
#       text: 'You are now marked for extermination.'
#     )
#
#     message.reply(
#       text: 'Have a nice day.'
#     )
#   end
# end
#
# Bot.on :postback do |postback|
#   case postback.payload
#   when 'HUMAN_LIKED'
#     text = 'That makes bot happy!'
#   when 'HUMAN_DISLIKED'
#     text = 'Oh.'
#   end
#
#   postback.reply(
#     text: text
#   )
# end
#
# Bot.on :delivery do |delivery|
#   puts "Delivered message(s) #{delivery.ids}"
# end
