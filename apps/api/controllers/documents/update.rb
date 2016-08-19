require_relative '../../../../lib/xdoc/interactors/render_asciidoc'
require_relative '../../../../lib/xdoc/modules/verify'

module Api::Controllers::Documents
  class Update
    include Api::Action
    include Permission

    def update_document(params)
      id = params['id']
      author_name = params['author_name']
      puts " --- id: #{id}"
      puts " --- author_name: #{author_name}"

      document = DocumentRepository.find(id)

      if document
        #  puts "\n\n\n\n#{params.inspect}\n\n\n\n"
        document.update_from_hash(params)
        @result = ::RenderAsciidoc.new(source_text: document.text).call
        document.rendered_text = @result.rendered_text
        puts "document.links: #{document.links}"
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
        update_document(params)
      else
        self.body = error_document_response('Sorry, you do not have access to that document')
      end

    end


    def verify_csrf_token?
      false
    end
  end
end
