require 'sinatra'
require 'active_record'
require "sinatra/activerecord"
require 'pg'
require "nokogiri"
require 'net/http'
require 'yaml'

configure :production do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: ENV['POSTGRESQL_DATABASE'], pool: 2, username: ENV['POSTGRESQL_USER'], password: ENV['POSTGRESQL_PASSWORD'], host: 'postgresql'}
end

configure :development do
  set :database, {adapter: "sqlite3", database: "some.sqlite3"}
end

class Session < ActiveRecord::Base
end

class Wtrust < ActiveRecord::Base
end
  
get '/' do
  content_type :json
  res = {:time => Time.now, :ip => request.ip}
  puts res.inspect
  res.to_json
end

get '/test' do
  content_type :json

  `curl --header 'Access-Token: #{ENV['PUSH_TOKEN']}' --header 'Content-Type: application/json' --data-binary '{"body":"#{Time.now.to_i}","title":"title","type":"note", "channel_tag": "test_push"}' --request POST https://api.pushbullet.com/v2/pushes`
  
  test = {:hello => "world"}
  test.to_json
end
