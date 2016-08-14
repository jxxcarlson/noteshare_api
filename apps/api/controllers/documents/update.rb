require_relative '../../../../lib/xdoc/interactors/render_asciidoc'
require_relative '../../../../lib/xdoc/modules/verify'

module Api::Controllers::Documents
  class Update
    include Api::Action
    include Permission

    def update_document(params)
      id = params['id']
      puts " --- id: #{id}"
      text = params['text']
      puts " --- text: #{text}"
      document = DocumentRepository.find(id)

      if document
        # puts "\n\n\n\n#{params.inspect}\n\n\n\n"
        document.update_from_hash(params)
        @result = ::RenderAsciidoc.new(source_text: document.text).call
        document.rendered_text = @result.rendered_text
        puts "document.links: #{document.links}"
        document.links['images'] = @result.image_map
        # document.rendered_text = document.rendered_text.gsub('href', 'ng-href')
        DocumentRepository.update document
        # response.status = 200
        hash = {'status' => 'success', 'document' => document.to_hash }
        self.body = hash.to_json
      else
        # response.status = 500
        self.body = { "error" => "500 Server error: document not updated" }.to_json
      end
    end

    def call(params)
      puts "API: update"
      verify_request(request)

      if @access.valid
        update_document(params)
      else
        reponse.status = 500
        self.body = error_document_response
      end
    end


    def verify_csrf_token?
      false
    end
  end
end
