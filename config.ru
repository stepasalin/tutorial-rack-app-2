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
  #return false unless parsed_json.is_a?(Hash)

  #required_fields = ['name', 'age']
  #required_fields.all? { |field| parsed_json.key?(field) }

end

run do |raw_request|
  redis = Redis.new
  parsed_request = Rack::Request.new(raw_request)
  body = parsed_request.body.read
  parsed_body = JSON.parse(body)
  name = parsed_body['name']
  age = parsed_body['age'].to_i

  if !parsed_request.post?
    [501,{},['Not Implemented. Please try method "POST"!']]
  elsif !parsed_request.path == '/api/user/new'
    [400,{},['Bad Request. Please try path "/api/user/new"!']]
  elsif !name
    [400,{},['ERROR! Field "name" is not found']]
  elsif !(name.size >=3 && name.size <=20)
    [400,{},['ERROR! The length of the name should be from 3 to 20 characters!']]
  elsif !valid_latin_string?(name)
    [400,{},['ERROR! The name must contain only Latin characters!']]
  elsif !(age>0 && age<100)
    [400,{},['ERROR! The age should be in the range from 0 to 100!']]
  else
    redis.set(name, body)
    [201,{},['User has been created!']]
  end
  rescue JSON::ParserError
    [400, {}, ['ERROR! Invalid JSON format!']]
end