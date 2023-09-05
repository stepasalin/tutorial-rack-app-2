require_relative '../app'

# любой request-тест имеет следуюущую структуру
# сетап (создание App, возможно что-то в базе)
# отправка запроса
# проверка ответа
# (опционально) проверка базы

describe 'API' do
  let(:app) { App.new }

  it 'creates User' do
    # под сомнением - create
    # все остальное, в частности find, считается "рабочим"
    request_params = {
      'REQUEST_PATH' => '/api/user/new',
      'PATH_INFO'=> '/api/user/new',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => StringIO.new('{"name": "Kolya","age": 90000}')
    }
    response = app.call(request_params)
    new_user = User.find('Kolya')

    # проверка ответа
    expect(response).to eq([201,{},['User has been created']])
    # проверка состояния базы
    expect(new_user).not_to be_nil # RSpec cheat sheet
  end

  #if 'finds user with a Get' do
    # под сомнением: поиск юзеров в базе и их выдача
    # все остальное в проекте на минутку считается точно рабочим
    # ДЗ
    # сформировать request_params аналогичные GET-запросу
    # проверить, что в ответе лежит правильный JSON с юзером
    # а откуда возьмется юзер в базе? фантазируйте!
    # не стесняйтесь пользоваться моделью User!
  #end
end