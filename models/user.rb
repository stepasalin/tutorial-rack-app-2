require 'json'
require 'redis'
require 'pry'

class User

  attr_reader :name, :age, :errors

  def initialize(name, age)
    @name = name
    @age = age
    @valid = valid
  end

  def valid
    @errors = []
    @errors << "Name length should be between 3 and 20 characters. \n" unless @name.length.between?(3, 20)
    @errors << "Name must contain only latin symbols. \n" unless @name.match?(/^[A-Za-z]+$/)
    @errors << "Age must be a positive value, actual value = #{@age}. \n" unless @age.to_i > 0  
    @errors.empty?
  end

  def to_json
    { name: @name, age: @age }.to_json
  end

  def save_1
    redis = Redis.new
    redis.set(@name, to_json)
  end

  def self.save(name, body)
    redis = Redis.new
    redis.set(name, body)
  end

  def self.find(user)
    redis = Redis.new
    redis.get(user)
  end

end
