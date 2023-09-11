    def generate_random_valid_name
        alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
        name_length = rand(3..20)
        name = (1..name_length).map {alphabet.sample}.join
        return name
    end

    def generate_random_valid_age
        age = rand(1..99)
        return age
    end

    def generate_random_invalid_name
        alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
        name_length = rand(1..2).even? ? rand(21..100) : rand(1..2)
        name = (1..name_length).map {alphabet.sample}.join
        return name
    end

    def generate_random_invalid_age
        age = rand(2).zero? ? rand(-999..-1) : rand(100..1000)
        return age
    end

    def create_user(name, age)
        user = User.new(name, age).save_1
        return user
    end

    def get(path)
        req_params = {
            'REQUEST_PATH' => path,
            'PATH_INFO'=> path,
            'REQUEST_METHOD' => 'GET'
        }
        response = app.call(req_params)
        return response
    end

    def post(path, name, age)
        req_params = {
            'REQUEST_PATH' => path,
            'PATH_INFO'=> path,
            'REQUEST_METHOD' => 'POST',
            'rack.input' => StringIO.new("{\"name\":\"#{name}\", \"age\":\"#{age}\"}"),
        }
        response = app.call(req_params)
        return response
    end
