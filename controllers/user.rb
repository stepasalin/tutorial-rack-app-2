require 'json'
require 'pry'
require 'redis'
require_relative '../models/user.rb'

class UserController
  attr_reader :pars_req, :errors, :valid

  def initialize(pars_req)
    @pars_req = pars_req
    @raw_body = pars_req.body.read
    @parsed_body = JSON.parse(@raw_body)
  end

  def create_user
    errors = []
    errors << "Fiend 'name' is absent. \n" unless @parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless @parsed_body["age"]
    return [422, {}, errors] if errors.any?

    new_user = User.new(@parsed_body["name"], @parsed_body["age"].to_i)
    return [422, {}, new_user.errors] unless new_user.valid

    User.save(@parsed_body["name"], @raw_body)
    
    [201, {}, ["User has been created"]]
  end

  def find_user
    requested_name = @pars_req.path.gsub('/api/user/',"")
    user_value = User.find(requested_name)
    return [200, {}, [user_value]] if user_value
    
    [404, {}, ["User #{requested_name} is not found"]]
  end 

  def modify_user
    errors = []
    errors << "Fiend 'name' is absent. \n" unless @parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless @parsed_body["age"]
    return [422, {}, errors] if errors.any?
    return User.save(@parsed_body["name"], @raw_body) if User.find(@parsed_body["name"])

    [422, {}, ["User #{@parsed_body["name"]} is not found to modify"]]
  end

  def delete_user
    errors = []
    errors << "Fiend 'name' is absent. \n" unless @parsed_body["name"]
    return [422, {}, errors] if errors.any?
    return User.delete(@parsed_body["name"]) if User.find(@parsed_body["name"])

    [422, {}, ["User #{@parsed_body["name"]} is not found to delete"]]
  end
end