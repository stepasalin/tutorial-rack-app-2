require 'json'
require 'pry'
require 'redis'
require_relative '../models/user.rb'

class UserController
  attr_reader :pars_req, :errors, :valid

  def initialize(pars_req)
    @pars_req = pars_req
    @raw_body = pars_req.body&.read
    @parsed_body = JSON.parse(@raw_body) if @raw_body
  end

  def create_user
    errors = []
    errors << "Field 'name' is absent. \n" unless @parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless @parsed_body["age"]
    return [422, {}, errors] if errors.any?

    new_user = User.new(@parsed_body["name"], @parsed_body["age"].to_i)
    return [422, {}, new_user.errors] unless new_user.valid

    new_user.save_1
    
    [201, {}, ["User has been created"]]
  end

  def find_user
    requested_name = @pars_req.path.gsub('/api/user/',"")
    user = User.find(requested_name)
    return [404, {}, ["User #{requested_name} is not found"]] if user.nil?
    
    [200, {}, [user.to_json]]
  end 

  def modify_user
    errors = []
    errors << "Field 'name' is absent. \n" unless @parsed_body["name"]
    errors << "Field 'age' is absent. \n" unless @parsed_body["age"]
    return [422, {}, errors] if errors.any?
    
    user = User.find(@parsed_body["name"])
    return [404, {}, ["User #{@parsed_body["name"]} is not found to modify"]] if user.nil?

    user.age = @parsed_body["age"]
    return [422, {}, user.errors] unless user.valid
    
    user.save_1
    [201, {}, ["Value was changed to #{user.to_json}"]]
  end

  def delete_user
    errors = []
    errors << "Field 'name' is absent. \n" unless @parsed_body["name"]
    return [422, {}, errors] if errors.any?
    return [422, {}, ["User #{@parsed_body["name"]} is not found to delete"]] unless User.find(@parsed_body["name"])
    
    User.delete(@parsed_body["name"])
    [200, {}, ["Value was deleled"]]
  end
end