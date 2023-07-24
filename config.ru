require 'rack'
require 'pry'
require 'redis'
require 'json'
require_relative 'models/user.rb'
require_relative 'controllers/user.rb'

run do |raw_request|
  parsed_request = Rack::Request.new(raw_request)

  #GET
  if parsed_request.get? && parsed_request.path.start_with?('/api/user/')
    requested_name = parsed_request.path.gsub('/api/user/',"")
    redis1 = Redis.new
    output = redis1.get(requested_name)
    if output
      [200, {}, [output]] 
    else
      [404, {}, ["User #{requested_name} is not found"]]
    end

  #POST  
  elsif parsed_request.post? && parsed_request.path == '/api/user/new'
    UserController.new(parsed_request).create_user
  end
  
rescue JSON::ParserError
  [400, {}, ['JSON format is invalid']]
end