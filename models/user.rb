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

end
