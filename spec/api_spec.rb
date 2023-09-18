require_relative '../app'
require_relative '../helpers/application_helper'


describe 'API - tests' do
  let(:app) { App.new }

  before(:each) do
    Redis.new.flushall
    @valid_name = generate_random_valid_name
    @valid_age = generate_random_valid_age
    @invalid_name = generate_random_invalid_name
    @invalid_age = generate_random_invalid_age
    @expected_hash = { "name" => @valid_name, "age" => @valid_age }
    @json_string = @expected_hash.to_json
  end


  it 'CREATE user' do
    response = post("/api/user/new", {"name" => @valid_name, "age" => @valid_age}.to_json)
    expect(response.code).to eq(201)
    expect(response.body_string).to eq("User has been created")
    expect(User.find(@valid_name)).not_to be_nil
  end

  it 'GET user' do
    create_user(@valid_name, @valid_age)
    response = get("/api/user/#{@valid_name}")
    expect(response.code).to eq(200)
    expect(response.body_hash).to eq(@expected_hash)
    expect(User.find(@valid_name)).not_to be_nil
  end

  it 'UPDATE user' do
    create_user(@valid_name, @valid_age+1)
    response = put("/api/user/modify", {"name" => @valid_name, "age" => @valid_age}.to_json)
    expect(response.code).to eq(201)
    expect(response.body_hash).to eq(@expected_hash)
    expect(User.find(@valid_name).age).to eq(@valid_age)
  end

  it 'DELETE user' do
    create_user(@valid_name, @valid_age)
    response = delete("/api/user/delete", {"name" => @valid_name}.to_json)
    expect(response.code).to eq(200)
    expect(response.body_string).to eq("Value was deleled")
    expect(User.find(@valid_name)).to be_nil 
  end

# NEGATIVE TESTS
  it 'CREATE (negative)' do
    response = post("/api/user/new", {"name" => @invalid_name, "age" => @invalid_age}.to_json)
    expect(response.code).to eq(422)
    expect(response.body_string).to match_array(["Name length should be between 3 and 20 characters. \n", "Age must be a positive value, actual value = #{@invalid_age}. \n"])
    expect(User.find(@invalid_name)).to be_nil 
  end

  it 'GET non-existence user' do
    non_existing_user_name = generate_random_valid_name
    response = get("/api/user/#{non_existing_user_name}")
    expect(response.code).to eq(404)
    expect(response.body_string).to eq("User #{non_existing_user_name} is not found")
  end

  it 'UPDATE non-existence user' do
    response = put("/api/user/modify", @json_string)
    expect(response.code).to eq(404)
    expect(response.body_string).to eq("User #{@valid_name} is not found to modify")
    expect(User.find(@valid_name)).to be_nil 
  end

  it 'DELETE non-existence user' do
    non_existing_user_name = generate_random_valid_name
    response = delete("/api/user/delete", {"name" => non_existing_user_name}.to_json)
    expect(response.code).to eq(422)
    expect(response.body_string).to eq("User #{non_existing_user_name} is not found to delete")
  end



end