require 'rack'
require 'pry'
require 'redis'
require 'json'

# ДЗ 1
# добавить в сервис валидации
# не должно быть возможности прислать невалидный JSON. Если таковой прислали - давать соответствующий ответ.
# не должно быть возможности прислать JSON без полей name и age. Придумать ответ
# ДОП валидации на name и age: name от 3 до 20 символов латиница, age - число больше нуля. Если нарушены - давать ответ.

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