class Greeting

  def self.enable
    # Greeting Text.
    Facebook::Messenger::Profile.set({
      greeting: [
        {
          locale: 'default',
          text: 'CricCric welcomes you! :)'
        }
      ]
    }, access_token: ENV['ACCESS_TOKEN'])
    # Get started button.
    Facebook::Messenger::Profile.set({
      get_started: {
        payload: 'START'
      }
    }, access_token: ENV['ACCESS_TOKEN'])
  end

end
