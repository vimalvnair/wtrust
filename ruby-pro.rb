pid = fork do
  count = 0
  while true
    `curl http://vimtunnel.localtunnel.me/`
    sleep 150
    count += 1

    if count == 48
      `bundle exec rake wtrust:load_current_data`
      count = 0
    end
  end
end
