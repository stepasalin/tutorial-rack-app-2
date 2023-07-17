require 'json'
require 'redis'

class User

  attr_reader :name, :age, :errors

  def initialize(name, age, body)
    @name = name
    @age = age
    @body = body
    valid
  end

  def valid
    @errors = []
    name_valid?
    age_valid?
    @errors.empty?
  end

  def name_valid?
    if @name.nil? 
      @errors << "Name must be present.\n" 
    elsif !@name.length.between?(3, 20)
      @errors << "Name length should be between 3 and 20 characters.\nActual length = #{@name.length}.\n"
    end
  end

  def age_valid?
    if @age.nil?
      @errors << "Age must be provided.\n"
    elsif @age.to_i < 0
      @errors << "Age must be a positive value, actual value = #{@age}."
    end
  end

  def create_user
    if name_valid? && age_valid?
      redis = Redis.new
      redis.set(@name, @body)
      [201, {}, ['User has been created!']]
    else [422, {}, @errors]
    end
  end
end