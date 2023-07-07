require 'rack'
require 'pry'
require 'redis'
require 'json'
require_relative './user.rb'

def valid_latin_string?(str)
  /^[A-Za-z]+$/.match?(str)
end

def valid_json?(json_str)
  parsed_json = JSON.parse(json_str)
  true
rescue JSON::ParserError
  false
end

 run do |raw_request|
  redis = Redis.new
  parsed_request = Rack::Request.new(raw_request)
  body = parsed_request.body.read


  if parsed_request.get? && parsed_request.path.start_with?('/api/user/')
    requested_name = parsed_request.path.gsub('/api/user/', "")
    output = redis.get(requested_name)
    if output
      [200, {}, [output]]
    else
      [404, {}, ["User #{requested_name} is not found"]]
    end
    
  elsif parsed_request.post? && parsed_request.path == '/api/user/new'
    parsed_body = JSON.parse(body)
    name = parsed_body['name'].to_s
    age = parsed_body['age'].to_i
    req_user = User.new(name, age)

    if parsed_body.nil?
      [400,{},['ERROR! JSON is absent!']]
    # elsif !name && !age
    #   [400,{},['ERROR! Fields "name" and "age" is not found']]
    # elsif !name
    #   [400,{},['ERROR! Field "name" is not found']]
    # elsif !age
    #   [400,{},['ERROR! Field "age" is not found']]
    elsif req_user.valid
      redis.set(name, body)
      [201,{},['User has been created!']]
    else
      [422,{},req_user.errors]
      
    end
  end
rescue JSON::ParserError
  [400, {}, ['ERROR! Invalid JSON format!']]
end