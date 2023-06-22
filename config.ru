require 'rack'
#require 'pry'
require 'redis'
require 'json'

# ДЗ 1
# добавить в сервис валидации
# не должно быть возможности прислать невалидный JSON. Если таковой прислали - давать соответствующий ответ.
# не должно быть возможности прислать JSON без полей name и age. Придумать ответ
# ДОП валидации на name и age: name от 3 до 20 символов латиница, age - число больше нуля. Если нарушены - давать ответ.

 
 run do |raw_request|
  redis = Redis.new
  parsed_request = Rack::Request.new(raw_request)
  body = parsed_request.body.read
  name = parsed_request.params['name']
  age = parsed_request.params['age']

  if parsed_request.post? && parsed_request.path == '/api/user/new'
    if body.nil?
      [400, {}, ['body is empty (Bad request)']]
    elsif valid_json = JSON.parse(body) rescue false
      [400, {}, ['JSON format is invalid']]
    elsif !parsed_request.params['name'] || !parsed_request.params['age']
      [400, {}, ['Required param is missed']]
    elsif !body.match?(/[A-Za-z]/)
      [400, {}, ['Body must contain only latin symbols']]
    elsif name.length < 3 || name.length > 20
      [400, {}, ['Name length should be between 3 and 20 symbols']]
    elsif age < 0
      [400, {}, ['age must be greater than zero']]
    else
      redis.set(name, body)
      [201, {}, ['User has been created!']]
    end
  end
end