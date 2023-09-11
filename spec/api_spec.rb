require_relative '../app'
require_relative '../helpers/application_helper'


describe 'API - tests' do
  let(:app) { App.new }

  before(:each) do
    @valid_name = generate_random_valid_name
    @valid_age = generate_random_valid_age
    @invalid_name = generate_random_invalid_name
    @invalid_age = generate_random_invalid_age
    @expected_hash = { "name" => @valid_name, "age" => @valid_age }
    @json_string = @expected_hash.to_json
  end


  it 'CREATE user' do
    response = post("/api/user/new", @json_string)
    expect(response.code).to eq(201)
    expect(response.body_string).to eq("User has been created")
    expect(User.find(@valid_name)).not_to be_nil
  end

  it 'GET user' do
    create_user(@valid_name, @valid_age)
    response = get("/api/user/#{@valid_name}")
    expect(response.body_hash).to eq(@expected_hash)
    expect(response.code).to eq(200)
  end

  it 'UPDATE user' do
    create_user(@valid_name, @valid_age+1)
    response = put("/api/user/modify", @json_string)
    expect(response.code).to eq(201)
    expect(response.body_hash).to eq(@expected_hash)
    expect(User.find(@valid_name)).not_to be_nil
  end

  it 'DELETE user' do
    user = User.new('Mark', '88')
    user.save
    request_params = {
      'REQUEST_PATH' => '/api/user/delete',
      'PATH_INFO'=> '/api/user/delete',
      'REQUEST_METHOD' => 'DELETE',
      'rack.input' => StringIO.new('{"name":"Mark"}')
    }
    response = app.call(request_params)
    new_user = User.find('Mark')

    expect(response).to eq([200, {}, ["Value was deleled"]])
    expect(new_user).to be_nil 
  end


end