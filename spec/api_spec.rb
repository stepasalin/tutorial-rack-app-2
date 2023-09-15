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

  it 'SEARCH(positive)' do
    create_user(@valid_name, @valid_age)
    response = get("/api/user/#{@valid_name}")
    expect(response.code).to eq(200)
    expect(response.body_hash).to eq(@expected_hash)
    expect(User.find(@valid_name)).not_to be_nil
  end

  it 'SEARCH(negative)' do
    non_existing_user_name = generate_random_valid_name
    response = get("/api/user/#{non_existing_user_name}")
    expect(response.code).to eq(404)
    expect(response.body_string).to eq("User #{non_existing_user_name} is not found")
  end

  it 'CREATION(positive)' do
    response = post("/api/user/new", {"name" => @valid_name, "age" => @valid_age}.to_json)
    expect(response.code).to eq(201)
    expect(response.body_string).to eq("User has been created")
  end

  it 'CREATION(negative)' do
    response = post("/api/user/new", {"name" => @invalid_name, "age" => @invalid_age}.to_json)
    expect(response.code).to eq(422)
    expect(response.body_string).to match_array(["Name length should be between 3 and 20 characters. \n", "Age must be a positive value, actual value = #{@invalid_age}. \n"])
    expect(User.find(@invalid_name)).to be_nil 
  end

  it 'MODIFY(positive)' do
    create_user(@valid_name, @valid_age+1)
    response = put("/api/user/modify", {"name" => @valid_name, "age" => @valid_age}.to_json)
    expect(response.code).to eq(201)
    expect(response.body_hash).to eq(@expected_hash)
    expect(User.find(@valid_name).age).to eq(@valid_age)
  end

  it 'MODIFY(negative)' do
    non_existing_user_name = generate_random_valid_name
    response = put("/api/user/modify", {"name" => non_existing_user_name, "age" => @valid_age}.to_json)
    expect(response.code).to eq(404)
    expect(response.body_string).to eq("User #{non_existing_user_name} is not found to modify")
    expect(User.find(non_existing_user_name)).to be_nil 
  end

  it 'DELETE(positive)' do
    create_user(@valid_name, @valid_age)
    response = delete("/api/user/delete", {"name" => @valid_name}.to_json)
    expect(response.code).to eq(200)
    expect(response.body_string).to eq("Value was deleled")
    expect(User.find(@valid_name)).to be_nil 
  end

  it 'DELETE(negative)' do
    non_existing_user_name = generate_random_valid_name
    response = delete("/api/user/delete", {"name" => non_existing_user_name}.to_json)
    expect(response.code).to eq(422)
    expect(response.body_string).to eq("User #{non_existing_user_name} is not found to delete")
  end


















  # it 'CREATION(negative)' do
  #   response = post("/api/user/new", @invalid_name, @invalid_age)
  #   expect(response).to eq([422, {}, ["Name length should be between 3 and 20 characters. \n", "Age must be a positive value, actual value = #{@invalid_age}. \n"]])
  # end

  # it 'MODIFY(positive)' do
  #   create_user(@valid_name, @valid_age)
  #   response = put("/api/user/modify", @valid_name, @valid_age + 1)
  #   response_hash = JSON.parse(response[2][0])
  #   expect(response_hash.keys).to eq(@expected_hash.keys)
  # end


  # it 'Check positive UPDATE of user' do
  #   user = User.new('rish', '34')
  #   user.save
  #   env = {
  #     'REQUEST_PATH' => '/api/user/modify',
  #     'PATH_INFO'=> '/api/user/modify',
  #     'REQUEST_METHOD' => 'PUT',
  #     'rack.input' => StringIO.new('{"name":"rish", "age":"40"}')
  #   }
  #   response = app.call(env)
  #   new_user = User.find('rish')

  #   expect(response).to eq([201, {}, ["Value was changed to {\"name\":\"rish\",\"age\":\"40\"}"]])
  #   expect(new_user).not_to be_nil
  # end

  # it 'Check negative UPDATE of user' do
  #   user = User.new('rish', '56')
  #   user.save
  #   env = {
  #     'REQUEST_PATH' => '/api/user/modify',
  #     'PATH_INFO'=> '/api/user/modify',
  #     'REQUEST_METHOD' => 'PUT',
  #     'rack.input' => StringIO.new('{"name":"rish7777", "age":"40"}')
  #   }
  #   response = app.call(env)
  #   new_user = User.find('rish7777')

  #   expect(response).to eq([404, {}, ["User rish7777 is not found to modify"]])
  #   expect(new_user).to be_nil 
  # end

  # it 'Check positive Search of user' do
  #   user = User.new('KOLYA', '34')
  #   user.save
  #   env = {
  #     'REQUEST_PATH' => '/api/user/KOLYA',
  #     'PATH_INFO'=> '/api/user/KOLYA',
  #     'REQUEST_METHOD' => 'GET'
  #   }
  #   response = app.call(env)

  #   expect(response).to eq([200,{},['{"name":"KOLYA","age":"34"}']])
  # end

  # it 'Check negative Search of user' do
  #   user = User.new('Masha', '34')
  #   user.save
  #   env = {
  #     'REQUEST_PATH' => '/api/user/Masha5',
  #     'PATH_INFO'=> '/api/user/Masha5',
  #     'REQUEST_METHOD' => 'GET'
  #   }
  #   response = app.call(env)

  #   expect(response).to eq([404,{},['User Masha5 is not found']])
  # end

  # it 'Check positive DELETE of user' do
  #   user = User.new('rishdel', '56')
  #   user.save
  #   env = {
  #     'REQUEST_PATH' => '/api/user/delete',
  #     'PATH_INFO'=> '/api/user/delete',
  #     'REQUEST_METHOD' => 'DELETE',
  #     'rack.input' => StringIO.new('{"name":"rishdel"}')
  #   }
  #   response = app.call(env)
  #   new_user = User.find('rishdel')

  #   expect(response).to eq([200, {}, ["Value was deleled"]])
  #   expect(new_user).to be_nil 
  # end

  # it 'Check negative DELETE of user' do
  #   user = User.new('rishnotdel', '56')
  #   user.save
  #   env = {
  #     'REQUEST_PATH' => '/api/user/delete',
  #     'PATH_INFO'=> '/api/user/delete',
  #     'REQUEST_METHOD' => 'DELETE',
  #     'rack.input' => StringIO.new('{"name":"rishdeldel"}')
  #   }
  #   response = app.call(env)
  #   new_user = User.find('rishdeldel')

  #   expect(response).to eq([422, {}, ["User rishdeldel is not found to delete"]])
  #   expect(new_user).to be_nil 
  # end
end