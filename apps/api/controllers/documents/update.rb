require_relative '../../../../lib/xdoc/interactors/render_asciidoc'
require_relative '../../../../lib/xdoc/modules/verify'
require_relative '../../../../lib/xdoc/interactors/update_document'

module Api::Controllers::Documents
  class Update
    include Api::Action
    include Permission

    def update_document(params)
      id = params['id']
      document = DocumentRepository.find(id)

      if document
        document.update_from_hash(params)
        @result = ::RenderAsciidoc.new(source_text: document.text).call
        document.rendered_text = @result.rendered_text
        document.links['images'] = @result.image_map
        DocumentRepository.update document
        hash = {'status' => 'success', 'document' => document.hash }
        self.body = hash.to_json
      else
        self.body = { "error" => "500 Server error: document not updated" }.to_json
      end
    end

    def call(params)
      puts "API: update"

      verify_request(request)

      if @access.valid && @access.username == params['author_name'] 
        result = UpdateDocument.new(params, request.query_string).call
        if result.status == 'success'
          self.body = result.hash
        else
          self.body = error_document_response('Sorry, something went wroing')
        end
      else
        self.body = error_document_response('Sorry, you do not have access to that document')
      end

    end


    def verify_csrf_token?
      false
    end

  end
end
