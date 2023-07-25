require 'json'
require 'pry'
require 'redis'

class UserController
  attr_reader :parsed_request, :errors, :valid

  def initialize(parsed_request)
    @parsed_request = parsed_request
    @raw_body = parsed_request.body.read
  end

  def create_user
    parsed_body = JSON.parse(@raw_body)
    errors = []
    errors << "Fiend 'name' is absent. \n" unless parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless parsed_body["age"]

    if errors.any?
      [422, {}, errors]
    else 
      new_user = User.new(parsed_body["name"], parsed_body["age"].to_i)
      if new_user.valid
        redis = Redis.new
        redis.set(parsed_body["name"], @raw_body)
        [201, {}, ["User has been created"]]
      else
        [422, {}, new_user.errors]
      end
    end
  end

  def find_user
    requested_name = @parsed_request.path.gsub('/api/user/',"")
    redis1 = Redis.new
    output = redis1.get(requested_name)
    if output
      [200, {}, [output]] 
    else
      [404, {}, ["User #{requested_name} is not found"]]
    end
  end 
end