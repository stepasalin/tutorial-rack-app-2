require_relative '../app'

describe 'API' do
  let(:app) { App.new }

  it 'creates User' do
    env = {
      'REQUEST_PATH' => '/api/user/new',
      'PATH_INFO'=> '/api/user/new',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => StringIO.new('{"name": "Kolya","age": 90000}')
    }
    response = app.call(env)
    expect(response).to eq([201,{},['User has been created']])
  end
end