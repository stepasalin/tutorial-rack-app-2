require 'rack'
require 'pry'
require 'redis'
require 'json'
require_relative 'models/user.rb'
require_relative 'controllers/user.rb'


 run do |raw_request|
  redis = Redis.new
  parsed_request = Rack::Request.new(raw_request)
  UserController.new(parsed_request)
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

    if req_user.valid
      redis.set(name, body)
      [201,{},['User has been created!']]
    else
      [422,{},req_user.errors]
    end
  end
rescue JSON::ParserError
  [400, {}, ['ERROR! Invalid JSON format!']]
end


# if req.post? && req.path = ....
#   UserController.create(req)
# elsif ...