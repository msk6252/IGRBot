# bot.rb
require 'http'
require 'json'

response = HTTP.post('https://slack.com/api/api.test')
puts JSON.pretty_generate(JSON.parse(response.body))

