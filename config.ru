require 'rack'
require 'pry'
require 'redis'
require 'json'

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
  parsed_body = JSON.parse(body)
  name = parsed_body['name']
  age = parsed_body['age']

  if parsed_request.get? && parsed_request.path.start_with?('/api/user/')
#    requested_name = parsed_request.path.gsub('/api/user/', "")
#    output = redis.get(requested_name)
#    if output
#      [200, {}, [output]]
#    else
#      [404, {}, ["User #{requested_name} is not found"]]
#    end
    binding.pry
  elsif parsed_request.post? && parsed_request.path == '/api/user/new'
    if parsed_body.nil?
      [400,{},['ERROR! JSON is absent!']]
    elsif !name && !age
      [400,{},['ERROR! Fields "name" and "age" is not found']]
    elsif !name
      [400,{},['ERROR! Field "name" is not found']]
    elsif !age
      [400,{},['ERROR! Field "age" is not found']]
    elsif !(name.size >=3 && name.size <=20)
      [400,{},['ERROR! The length of the name should be from 3 to 20 characters!']]
    elsif !valid_latin_string?(name)
      [400,{},['ERROR! The name must contain only Latin characters!']]
    elsif !(age.to_i>0 && age.to_i<100)
      [400,{},['ERROR! The age should be in the range from 0 to 100!']]
    else
      redis.set(name, body)
      [201,{},['User has been created!']]
    end
  end
rescue JSON::ParserError
  [400, {}, ['ERROR! Invalid JSON format!']]
end