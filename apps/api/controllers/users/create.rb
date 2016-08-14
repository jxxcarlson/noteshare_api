
require_relative '../../../../lib/xdoc/interactors/grant_access'

module Api::Controllers::Users
  class Create
    include Api::Action

    def create_document(user)
      document = NSDocument.new(owner_id: user.id, title: 'First Document')
      document.text = 'This is only a test.'
      document.kind = 'text'
      document.public = false
      text = 'This is only a test'
      document.rendered_text = RenderAsciidoc.new(source_text: text).call.rendered_text
      document = DocumentRepository.create document
      document
    end

    def call(params)
      result = CreateUser.new(params).call

      # self.body = "username = #{params['username']}, password = #{params['password']}, password_confirmation = #{params['password_confirmation']}, email = #{params['email']} "
      if result.err
        error = result.err[1]
        # response.status = 500
        self.body = { :status => result.status, :error => error }.to_json
      else
        user = result.user
        error = 'None'
        document = create_document(user)
        puts "DOC: #{document.id}, title: #{document.title}"
        # response.status = 200
        access= AccessToken.new(username: params[:username], password: params[:password]).call
        self.body = { :status => result.status, :error => error, :token => access.token }.to_json
      end

    end
  end
end
