require_relative '../app'

describe 'API - ' do
  let(:app) { App.new }

  it 'Check positive CREATION of user' do
    env = {
      'REQUEST_PATH' => '/api/user/new',
      'PATH_INFO'=> '/api/user/new',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => StringIO.new('{"name":"Kolya", "age":"40"}')
    }
    response = app.call(env)
    new_user = User.find('Kolya')

    expect(response).to eq([201,{},['User has been created']])
    expect(new_user).not_to be_nil
  end

  it 'Check negative CREATION of user' do
    env = {
      'REQUEST_PATH' => '/api/user/new',
      'PATH_INFO'=> '/api/user/new',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => StringIO.new('{"name":"2K", "age":"-40"}')
    }
    response = app.call(env)
    new_user = User.find('2K')

    expect(response).to eq([422, {}, ["Name length should be between 3 and 20 characters. \n", "Name must contain only latin symbols. \n", "Age must be a positive value, actual value = -40. \n"]])
    expect(new_user).to be_nil
  end

  it 'Check positive UPDATE of user' do
    user = User.new('rish', '34')
    user.save_1
    env = {
      'REQUEST_PATH' => '/api/user/modify',
      'PATH_INFO'=> '/api/user/modify',
      'REQUEST_METHOD' => 'PUT',
      'rack.input' => StringIO.new('{"name":"rish", "age":"40"}')
    }
    response = app.call(env)
    new_user = User.find('rish')

    expect(response).to eq([201, {}, ["Value was changed to {\"name\":\"rish\",\"age\":\"40\"}"]])
    expect(new_user).not_to be_nil
  end

  it 'Check negative UPDATE of user' do
    user = User.new('rish', '56')
    user.save_1
    env = {
      'REQUEST_PATH' => '/api/user/modify',
      'PATH_INFO'=> '/api/user/modify',
      'REQUEST_METHOD' => 'PUT',
      'rack.input' => StringIO.new('{"name":"rish7777", "age":"40"}')
    }
    response = app.call(env)
    new_user = User.find('rish7777')

    expect(response).to eq([404, {}, ["User rish7777 is not found to modify"]])
    expect(new_user).to be_nil 
  end

  it 'Check positive Search of user' do
    user = User.new('KOLYA', '34')
    user.save_1
    env = {
      'REQUEST_PATH' => '/api/user/KOLYA',
      'PATH_INFO'=> '/api/user/KOLYA',
      'REQUEST_METHOD' => 'GET'
    }
    response = app.call(env)

    expect(response).to eq([200,{},['{"name":"KOLYA","age":"34"}']])
  end

  it 'Check negative Search of user' do
    user = User.new('Masha', '34')
    user.save_1
    env = {
      'REQUEST_PATH' => '/api/user/Masha5',
      'PATH_INFO'=> '/api/user/Masha5',
      'REQUEST_METHOD' => 'GET'
    }
    response = app.call(env)

    expect(response).to eq([404,{},['User Masha5 is not found']])
  end

  it 'Check positive DELETE of user' do
    user = User.new('rishdel', '56')
    user.save_1
    env = {
      'REQUEST_PATH' => '/api/user/delete',
      'PATH_INFO'=> '/api/user/delete',
      'REQUEST_METHOD' => 'DELETE',
      'rack.input' => StringIO.new('{"name":"rishdel"}')
    }
    response = app.call(env)
    new_user = User.find('rishdel')

    expect(response).to eq([200, {}, ["Value was deleled"]])
    expect(new_user).to be_nil 
  end

  it 'Check negative DELETE of user' do
    user = User.new('rishnotdel', '56')
    user.save_1
    env = {
      'REQUEST_PATH' => '/api/user/delete',
      'PATH_INFO'=> '/api/user/delete',
      'REQUEST_METHOD' => 'DELETE',
      'rack.input' => StringIO.new('{"name":"rishdeldel"}')
    }
    response = app.call(env)
    new_user = User.find('rishdeldel')

    expect(response).to eq([422, {}, ["User rishdeldel is not found to delete"]])
    expect(new_user).to be_nil 
  end

end