require_relative '../../../../lib/xdoc/modules/aws'

include AWS

module Api::Controllers::Documents
  class Print
    include Api::Action




      def  get_document(id)
        puts "API: read id = #{id}"
        if id =~ /\A[1-9][0-9]*\z/
          DocumentRepository.find(id)
        else
          DocumentRepository.find_by_identifier(id)
        end
      end


      def call(params)

        puts "controller Print, id = #{params['id']}"

        token = request.env["HTTP_ACCESSTOKEN"]
        @access = GrantAccess.new(token).call

        if @access.valid
          document = get_document(params['id'])
          result = PrintDocument.new(document).call
          puts "printUrl: #{result.url}"
          self.body = {status: 'success', url: result.url}.to_json
        else
          self.body = error_document_response
        end

      end


      def verify_csrf_token?
        false
      end



  end
end
