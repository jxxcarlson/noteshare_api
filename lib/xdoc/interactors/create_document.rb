require 'hanami/interactor'



class CreateDocument

  include Hanami::Interactor


  def initialize(params, author_id)
    @options = params['options']
    @current_document_id =params['current_document_id']
    @parent_document_id = params['parent_document_id']
    @document = NSDocument.new(params)
    @author = UserRepository.find author_id
  end

  def create
    @document.owner_id = @author.id
    @document.author_name = @author.username
    @document = DocumentRepository.create @document
  end

  def attach

    if @options['child'] == true
      parent_document = DocumentRepository.find @current_document_id
      if parent_document
        parent_document.append_to_documents_link @document
      end
      DocumentRepository.update parent_document
    end

    if (@options['position'] == 'above') || (@options['position'] == 'below')

      parent_document = DocumentRepository.find @parent_document_id
      current_document = DocumentRepository.find @current_document_id
      if parent_document == nil or current_document == nil
        return 'error'
      end

      last_index = parent_document.links['documents'].count
      parent_document.append_to_documents_link @document
      target_index = parent_document.index_of_subdocument current_document
      target_index -= 1 if @options['position'] == 'below'
      parent_document.move_subdocument(last_index, target_index)

      DocumentRepository.update parent_document
      return 'success'
    end


  end

  def call
    create
    attach
  end

end




