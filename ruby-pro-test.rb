pid = fork do
  count = 0
  while true
    `curl http://vimtunnel.localtunnel.me/`
    sleep 150
    count += 1

    if count == 48
      `curl --header 'Access-Token: #{ENV['PUSH_TOKEN']}' --header 'Content-Type: application/json' --data-binary '{"body":"test","title":"title","type":"note", "channel_tag": "test_push"}' --request POST https://api.pushbullet.com/v2/pushes`
      count = 0
    end
  end
end
