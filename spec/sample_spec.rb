class PlusOne
  def initialize(number)
    raise 'Not a number' unless number.is_a?(Integer)

    @number = number
  end

  def plusone
    @number + 1
  end
end

# RSpec cheat sheet
# 99% expect(A).to eq(B)
# A == B

# Когда мы выполняем rspec spec, то он исполняет все тесты в папке spec
# ВАЖНО: исполнятся только файлы, которые заканчиваются на _spec.rb

RSpec.describe PlusOne do
  context 'simple tests' do
    it 'adds one' do
      obj = PlusOne.new(1)
      expect(obj.plusone).to eq 2
    end

    it 'refuses to work with anything but numbers' do
      expect { PlusOne.new('string') }.to raise_error
    end

    # формат имени принятый в taxdome
    # it 'as an РОЛЬ I want ЧТО-ТО to СДЕЛАТЬ ДЕЙСТВИЕ'
    # it 'as an owner I want delete tag button to delete tag'
  end

  context 'better test' do
    let(:base_number) { rand(1..1000) }

    before(:all) do
      puts 'Before all tests with let'
    end

    after(:all) do
      puts 'After all tests with let'
    end

    before(:each) do
      puts 'Before test with let'
    end

    after(:each) do
      puts 'After test with let'
    end

    it 'adds one' do
      obj = PlusOne.new(base_number)
      expect(obj.plusone).to eq(base_number + 1)
    end

    it 'does not add 2' do
      obj = PlusOne.new(base_number)
      expect(obj.plusone).not_to eq(base_number + 2)
    end
  end
end

