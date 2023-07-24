require 'json'
require 'pry'
require 'redis'

class UserController
  attr_reader :parsed_request, :errors, :valid

  def initialize(parsed_request)
    @body = parsed_request.body.read
    @name = JSON.parse(@body)["name"]
    @age = JSON.parse(@body)["age"]
    @valid = valid
  end

  def valid
    @errors = []
    @errors << "body is empty (Bad request). \n" unless @body
    @errors << "Fiend 'name' is absent. \n" unless @name
    @errors << "Field 'age' is absent. \n" unless @age
    @errors.empty?
  end

  def create_user
    test = User.new(@name, @age)
    if valid && test.valid
      redis = Redis.new
      redis.set(@name, @body)
      [201, {}, ["User has been created"]]
    else
      response = @errors + test.errors
      [422, {}, response]
    end
  end
end









  