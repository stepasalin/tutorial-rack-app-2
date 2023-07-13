require 'pry'

class UserController
  attr_reader :parsed_request, :errors, :valid

  def initialize(parsed_request)
    @parsed_request = parsed_request
    @body = parsed_request.body.read
    @name = JSON.parse(@body)["name"]
    @age = JSON.parse(@body)["age"]
    @valid = valid?
  end

  def valid?
    @errors = []
    @errors << "Field 'name' is absent" unless @name
    @errors << "Field 'age' is absent" unless @age
  end


end