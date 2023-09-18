class Response

  def initialize(response_array)
    @response_array = response_array
  end
  
  def code
    @response_array[0]
  end
  
  def body_string
    if @response_array[2].count == 1
      @response_array[2][0]
    else
      @response_array[2]
    end
  end
  
  def body_hash
    return JSON.parse(body_string.sub('Value was changed to ', '')) if body_string.include?('Value was changed to')
    
    JSON.parse(body_string)
  end
end


def generate_random_valid_name
  alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
  name_length = rand(3..20)
  (1..name_length).map {alphabet.sample}.join
end

def generate_random_valid_age
  age = rand(1..99)
end

def generate_random_invalid_name
  alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
  invalid_name_length = [rand(21..100), rand(1..2)].sample
  (1..invalid_name_length).map {alphabet.sample}.join
end

def generate_random_invalid_age
  rand(-999..-1)
end

def create_user(name, age)
  User.new(name, age).save
end

def get(path)
  req_params = {
    'REQUEST_PATH' => path,
    'PATH_INFO'=> path,
    'REQUEST_METHOD' => 'GET'
    }
  response_array = app.call(req_params)
  response = Response.new(response_array)
end

def post(path, json_string)
  req_params = {
    'REQUEST_PATH' => path,
    'PATH_INFO'=> path,
    'REQUEST_METHOD' => 'POST',
    'rack.input' => StringIO.new(json_string)
    }
  response_array = app.call(req_params)
  response = Response.new(response_array)
end

def put(path, json_string)
  req_params = {
    'REQUEST_PATH' => path,
    'PATH_INFO'=> path,
    'REQUEST_METHOD' => 'PUT',
    'rack.input' => StringIO.new(json_string)
    }
  response_array = app.call(req_params)
  response = Response.new(response_array)
end

def delete(path, json_string)
  req_params = {
    'REQUEST_PATH' => path,
    'PATH_INFO'=> path,
    'REQUEST_METHOD' => 'DELETE',
    'rack.input' => StringIO.new(json_string)
    }
  response_array = app.call(req_params)
  response = Response.new(response_array)
end