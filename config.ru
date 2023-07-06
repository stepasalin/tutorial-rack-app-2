require 'rack'
require 'pry'
require 'redis'
require 'json'
require 'user.rb'

# ДЗ 1
# добавить в сервис валидации
# не должно быть возможности прислать невалидный JSON. Если таковой прислали - давать соответствующий ответ.
# не должно быть возможности прислать JSON без полей name и age. Придумать ответ
# ДОП валидации на name и age: name от 3 до 20 символов латиница, age - число больше нуля. Если нарушены - давать ответ.




 run do |raw_request|
  redis = Redis.new
  parsed_request = Rack::Request.new(raw_request)
  body = parsed_request.body.read
  
  

  if parsed_request.get? && parsed_request.path.start_with?('/api/user/')
    requested_name = parsed_request.path.gsub('/api/user/',"")
    output = redis.get(requested_name)
    if output
      [200, {}, [output]] 
    else
      [404, {}, ["User #{requested_name} is not found"]]
    end


  elsif parsed_request.post? && parsed_request.path == '/api/user/new'
    parsed_body = JSON.parse(body)
    name = parsed_body['name']
    age = parsed_body['age'].to_i
    user_is_valid = User.new(name, age)
    if parsed_body.nil?
      [400, {}, ['body is empty (Bad request)']]
    elsif !name && !age
      [400, {}, ['Missing parameters: name and age']]
    elsif !name
      [400, {}, ['Missing parameter: name']]
    elsif !age
      [400, {}, ['Missing parameter: age']]
    elsif 
      user_is_valid
    # elsif !name.match?(/^[A-Za-z]+$/)
    #   [400, {}, ['Name must contain only latin symbols']]
    # elsif name.length < 3 || name.length > 20
    #   [400, {}, ['Name length should be between 3 and 20 symbols']]
    # elsif age < 0
    #   [400, {}, ['age must be greater than zero']]
    else
      redis.set(name, body)
      [201, {}, ['User has been created!']]
    end
  end
rescue JSON::ParserError
  [400, {}, ['JSON format is invalid']]
end