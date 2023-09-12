require 'json'
require 'redis'
require 'pry'

class User

  attr_accessor :name, :age, :errors

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

  def save
    redis = Redis.new
    redis.set(@name, to_json)
  end

  def self.find(c)
    redis = Redis.new
    redis_result = redis.get(c)
    return nil if redis_result.nil?

    parsed_result = JSON.parse(redis_result)
    User.new(parsed_result['name'], parsed_result['age'])
  end

  def self.delete(d)
    redis = Redis.new
    redis.del(d)
  end
end