class PersistentMenu

  def self.enable
    Facebook::Messenger::Profile.set({
      persistent_menu: [
        {
          locale: 'default',
          composer_input_disabled: false,
          call_to_actions: [
            {
              type: 'web_url',
              title: 'Breaking cricket news!',
              url: 'https://www.cricbuzz.com/cricket-news',
              webview_height_ratio: 'full'
            },
            {
              type: 'web_url',
              title: 'Highlights & Videos',
              url: 'https://www.icc-cricket.com/video',
              webview_height_ratio: 'full'
            },
            {
              title: 'Invite & Share',
              type: 'postback',
              payload: 'SHARE_AND_INVITE'
            }
            # {
            #   title: 'Many more',
            #   type: 'nested',
            #   call_to_actions: [
            #     {
            #       title: 'Contact Info',
            #       type: 'postback',
            #       payload: 'CONTACT_INFO_PAYLOAD'
            #     }
            #   ]
            # }
          ]
        }
      ]
    }, access_token: ENV['ACCESS_TOKEN'])
  end

end
