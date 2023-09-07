require 'rack'
require 'pry'
require 'redis'
require 'json'
require_relative 'models/user.rb'
require_relative 'controllers/user.rb'

class App
  def call(request_params)
    pars_req = Rack::Request.new(request_params)
    #binding.pry
    if pars_req.get? && pars_req.path.start_with?('/api/user/')
      UserController.new(pars_req).find_user
    elsif pars_req.post? && pars_req.path == '/api/user/new'
      UserController.new(pars_req).create_user
    elsif pars_req.put? && pars_req.path == '/api/user/modify'
      UserController.new(pars_req).modify_user
    elsif pars_req.delete? && pars_req.path == '/api/user/delete'
      UserController.new(pars_req).delete_user
    else
      [404, {}, ['Not Found']] 
    end
    rescue JSON::ParserError
    [400, {}, ['JSON format is invalid']]
  end
end