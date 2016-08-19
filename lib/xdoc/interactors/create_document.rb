require 'hanami/interactor'



class CreateDocument

  include Hanami::Interactor


  expose :new_document, :parent_document, :status

  def initialize(params, author_id)
    @params = params
    @author_id = author_id
    @options = JSON.parse(params['options'])
  end

  def create
    document = NSDocument.new(@params)
    author = UserRepository.find @author_id
    document.owner_id = author.id
    document.author_name = author.username
    @new_document = DocumentRepository.create document
    puts "CreateDocument: created #{@new_document.title} (#{@new_document.id})"
    @status = 'success'
  end

  def attach

    puts 'Entering attach document'
    puts "  @options = #{@options}"
    puts "  @options = #{@options.inspect}"
    puts "  @options = #{@options.class.name}"


    puts "  @options['child'] = #{@options['child']}"
    puts "  @options['position'] = #{@options['position']}"

    if @options['child'] == true
      puts "  -- Create child document ..., current document id = #{@params['current_document_id']}"
      @parent_document = DocumentRepository.find @params['current_document_id']
      if @parent_document
        @parent_document.append_to_documents_link @new_document
        DocumentRepository.update @parent_document
        puts "CreateDocument: attached #{@new_document.title} to #{@parent_document.title}"
        @status = 'success'
      else
        @status = 'error'
      end
    end

    if (@options['position'] == 'above') || (@options['position'] == 'below')

      @parent_document = DocumentRepository.find @params['parent_document_id']
      current_document = DocumentRepository.find @params['current_document_id']
      if @parent_document == nil or current_document == nil
        @status = 'error'
      end

      last_index = @parent_document.links['documents'].count
      @parent_document.append_to_documents_link @new_document
      puts "CreateDocument: attached #{@new_document.title} to #{@parent_document.title}"
      target_index = @parent_document.index_of_subdocument current_document
      target_index += 1 if @options['position'] == 'below'
      @parent_document.move_subdocument(last_index, target_index)
      puts "CreateDocument: movde #{@new_document.title} to index #{target_index} of #{@parent_document.title}"

      DocumentRepository.update @parent_document
      @status = 'success'
    end

  end

  def call
    create
    attach
  end

end




