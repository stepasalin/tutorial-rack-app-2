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
    @errors << "Name #{@name} is not valid!" unless @name.match?(/^[A-Za-z]+$/)
    @errors << "Name #{@name} length should be between 3 and 20 symbols" unless @name.length > 3 && @name.length < 20
    @errors << "Age must be greater than zero. Your age is #{@age}" unless @age > 0
    @errors.empty?
  end
end

person1 = User.new("Dima", 10)
person2 = User.new("Di", 11)
person3 = User.new("32423", 12)
person4 = User.new("Petya", 0)
person5 = User.new("Qwertyuiopasdfghjklzxc", 22)

binding.pry
