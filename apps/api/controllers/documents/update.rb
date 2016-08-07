require_relative '../../../../lib/xdoc/interactors/render_asciidoc'
require_relative '../../../../lib/xdoc/modules/verify'

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
        puts "document.links: #{document.links}"
        document.links['images'] = @result.image_map
        # document.rendered_text = document.rendered_text.gsub('href', 'ng-href')
        DocumentRepository.update document
        hash = {'status' => '202', 'document' => document.to_hash }
        self.body = hash.to_json
      else
        self.body = '{ "response" => "500 Server error: document not updated" }'
      end
    end

    def call(params)

     verify(params)

      if @result.valid
        update_document(params)
      else
        deny_access
      end
    end


    def verify_csrf_token?
      false
    end
  end
end
