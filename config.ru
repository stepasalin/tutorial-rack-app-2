require 'rack'
require 'pry'
require 'redis'
require 'json'

 run do |raw_request|
   parsed_request = Rack::Request.new(raw_request)
   if parsed_request.post? && parsed_request.path == '/api/user/new'
    body = parsed_request.body.read
    redis = Redis.new
    parsed_body = JSON.parse(body)
    name = parsed_body['name']
    redis.set(name, body)
    [201,{},['User has been created!']]
   end
 end