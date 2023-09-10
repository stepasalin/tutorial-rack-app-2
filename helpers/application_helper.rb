    def generate_random_name()
        alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
        name_length = rand(3..20)
        name = (1..name_length).map {alphabet.sample}.join
        return name
    end

    def generate_random_age
        age = rand(1..99)
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
