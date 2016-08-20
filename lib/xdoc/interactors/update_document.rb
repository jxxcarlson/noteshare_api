require 'hanami/interactor'
require_relative 'render_asciidoc'


class UpdateDocument
  include Hanami::Interactor

  expose :updated_document, :hash,  :status

  def initialize(params, query_string)
    @params = params
    @query_string = query_string || ""
  end

  def update
    id = @params['id']
    document = DocumentRepository.find(id)

    if document
      document.update_from_hash(@params)
      result = ::RenderAsciidoc.new(source_text: document.text).call
      document.rendered_text = result.rendered_text
      document.links['images'] = result.image_map
      @updated_document = DocumentRepository.update document
      @hash = {'status' => 'success', 'document' => document.hash }.to_json
      @status = 'success'
    else
      @hash = { "error" => "500 Server error: document not updated" }.to_json
      @status = 'error'
    end
  end

  def move_subdocument
    # query_string = 'move_up=22', where 22 is
    # the id of the subdocument to move up
    id = @params['id']
    document = DocumentRepository.find(id)
    subdocument_id = @query_string.split('=')[1]
    subdocument = DocumentRepository.find(subdocument_id) if subdocument_id

    if document && subdocument
      case @query_string
        when /up/
          document.move_up(subdocument)
        when /down/
          document.move_down(subdocument)
      end
      @updated_document = DocumentRepository.update document
      @hash = {'status' => 'success', 'document' => document.hash }.to_json
      @status = 'success'
    else
      @hash = { "error" => "500 Server error: document not updated" }.to_json
      @status = 'error'
    end
  end

  def call
    # http://blog.honeybadger.io/rubys-case-statement-advanced-techniques/
    case @query_string
      when ''
        update
      when /move/
        move_subdocument
    end
  end

end
