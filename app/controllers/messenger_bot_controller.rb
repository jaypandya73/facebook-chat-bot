class MessengerBotController < ActionController::Base
  def message(event, sender)
    # profile = sender.get_profile(:first_name) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    puts "I am here"
    puts "#{event['message']['text']}"
    sender.reply({ text: "#{event['message']['text']}" })
  end

  def delivery(event, sender)
    puts "#{event}"
    puts "I am in delivery"
  end

  def postback(event, sender)
    puts "I am in postback"
    payload = event["postback"]["payload"]
    case payload
    when :hello
      sender.reply({text: "Sorry don;t like hello"})
    end
  end
end