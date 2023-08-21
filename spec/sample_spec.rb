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

  it 'adds one' do
    obj = PlusOne.new(1)
    expect(obj.plusone).to eq 2
  end

  it 'refuses to work with anything but numbers' do
    expect { PlusOne.new('string') }.to raise_error
  end
end

