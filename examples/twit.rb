gem 'httparty'
require 'httparty'
require 'pp'

class Twit
  include HTTParty
  base_uri 'twitter.com'
  format :json

  def self.fetch(user_id)
    get("/users/show/#{user_id}.json")
  end

end

p Twit.get('http://twitter.com/users/show/hosheng.json')
p Twit.fetch('hosheng')
