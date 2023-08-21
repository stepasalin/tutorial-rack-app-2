class PlusOne
  def initialize(number)
    raise 'Not a number' unless number.is_a?(Integer)

    @number = number
  end

  def plusone
    @number + 1
  end
end

RSpec.describe PlusOne do
  context 'simple tests' do
    it 'adds one' do
      obj = PlusOne.new(1)
      expect(obj.plusone).to eq 2
    end

    it 'refuses to work with anything but numbers' do
      expect { PlusOne.new('string') }.to raise_error
    end
  end

  context 'better test' do
    let(:base_number) { rand(1..200) }

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

