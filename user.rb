require 'pry'

class User
  attr_reader :name, :age, :errors, :valid

  def initialize(name, age)
      @name = name
      @age = age
      @valid = valid?
  end

  def valid?
    @errors = []
    @errors << "Name #{@name} is not valid! " unless @name.match?(/^[A-Za-z]+$/)
    @errors << "Name #{@name} length should be between 3 and 20 symbols. " unless @name.length > 3 && @name.length < 20
    @errors << "Age must be greater than zero. Your age is #{@age}. " unless @age > 0
    @errors << "Fields 'name' and 'age' are not found. " unless !@name && !@age
    @errors << "Field 'name' is not found. " unless !@name
    @errors << "Field 'age' is not found. " unless !@age
    @errors.empty?
  end
end
