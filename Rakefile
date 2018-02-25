# Rakefile
require "sinatra/activerecord/rake"
require 'httparty'
require 'json'
require './app'

namespace :db do
  task :load_config do
    require "./app"
  end
end

namespace :wtrust do
  task :load_current_data do
    begin
      token, client_guid = login_wtrust
      resp = HTTParty.get("https://wealthtrust.in/api/api/SyncPortfolioValues?ClientGUID=#{client_guid}&PortfolioType=2", :headers => {"Token" => token})
      raise Exception.new("Failed to get portfolio info") unless resp.code == 200
      parsed_body = JSON.parse(resp.body)
      raise Exception.new("Wrong portfolio response") unless parsed_body['WAPIResponseStatus'] == "OK"
      resp_data = parsed_body['WAPIResponse']['ResponseData']

      wtrust = Wtrust.where(:total_gain => resp_data['TotalGain'], :day_gain => resp_data["DayGain"]).last

      if wtrust.nil? || (wtrust.created_at.strftime("%Y-%m-%d") != Time.now.utc.strftime("%Y-%m-%d"))
        new_wtrust = Wtrust.create(:total_gain => resp_data['TotalGain'], :total_investment_val => resp_data["TotalInvestmentVal"], :total_current_val => resp_data["TotalCurrentVal"], :day_gain => resp_data["DayGain"], :day_gain_percent => resp_data["DayGainPerc"], :xirr => resp_data["XIRR"])

        `curl --header 'Access-Token: #{ENV['PUSH_TOKEN']}' --header 'Content-Type: application/json' --data-binary '{"body":"#{new_wtrust.attributes.map{|k,v| [k, v.to_s] }.join("#")}","title":"Wtrust portfolio synced","type":"note", "channel_tag": "test_push"}' --request POST https://api.pushbullet.com/v2/pushes`
      end

    rescue Exception => e
      `curl --header 'Access-Token: #{ENV['PUSH_TOKEN']}' --header 'Content-Type: application/json' --data-binary '{"body":"#{e.message}","title":"Wtrust Exception","type":"note", "channel_tag": "test_push"}' --request POST https://api.pushbullet.com/v2/pushes`
      puts "Exception #{e.message}"
    end
  end

  def login_wtrust
    resp = HTTParty.post('https://wealthtrust.in/api/api/ClientLoginCheckV2', :body => {"EmailId": "#{ENV['WEMAIL']}","PassWord": "#{ENV['WPASSWORD']}"}.to_json, :headers => {"Content-Type" => "application/json", "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.167 Safari/537.36"})
    
    if resp.code == 200
      parsed_body = JSON.parse(resp.body)
      raise Exception.new("Wrong status") unless parsed_body["WAPIResponse"]["Status"] == 1
      token = parsed_body["WAPIResponse"]["data"]["Token"]
      client_guid = parsed_body["WAPIResponse"]["data"]["ClientGUID"]
      raise Exception.new("Wrong data") if token.nil? || token.empty?
    end
    [token, client_guid]
  end
end
