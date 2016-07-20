module Api::Controllers::Documents
  class Find
    include Api::Action

    def call(params)

      self.body = "query string: #{request.query_string}"

    end


    def verify_csrf_token?
      false
    end

  end
end
