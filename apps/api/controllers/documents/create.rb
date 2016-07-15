module Api::Controllers::Documents
  class Create
    include Api::Action

    def call(params)
      puts "API: creating document"
      document = NSDocument.new(params)
      DocumentRepository.create document
      self.body = "OK"
    end

    def verify_csrf_token?
      false
    end

  end
end
