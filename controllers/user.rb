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
    errors << "Field 'name' is absent. \n" unless parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless parsed_body["age"]
    return [422, {}, errors] if errors.any?

    new_user = User.new(@parsed_body["name"], @parsed_body["age"].to_i)
    return [422, {}, new_user.errors] unless new_user.valid
    return [422, {}, ["User #{@parsed_body["name"]} exists."]] if User.find(@parsed_body["name"])
    new_user.save
    
    [201, {}, ["User has been created"]]
  end


  def find_user
    requested_name = @parsed_request.path.gsub('/api/user/',"")
    user_value = User.find(requested_name)
    return [200, {}, [user_value]] if user_value
    [404, {}, ["User #{requested_name} is not found"]]
  end

  def modify_user
    errors = []
    errors << "Field 'name' is absent. \n" unless @parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless @parsed_body["age"]
    return [422, {}, errors] if errors.any?
    return [404, {}, ["User #{@parsed_body["name"]} is not found to modify"]] unless User.find(@parsed_body["name"])

    User.save(@parsed_body["name"], @raw_body)
    [201, {}, ["Value was changed to #{@raw_body}"]]
  end

  def delete_user
    errors = []
    errors << "Field 'name' is absent. \n" unless @parsed_body["name"]
    return [422, {}, errors] if errors.any?
    return [422, {}, ["User #{@parsed_body["name"]} is not found to modify"]] unless User.find(@parsed_body["name"])

    User.delete(@parsed_body["name"])
    [201, {}, ["Value was deleted"]]
  end
end