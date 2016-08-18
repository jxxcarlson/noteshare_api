require 'hanami/interactor'
require_relative '../../../lib/xdoc/modules/aws'


class PrintDocument

  include Hanami::Interactor
  include AWS

  expose :url

  def initialize(document)
    # Assume that document is an object or numerical id
    if document.class.name == 'NSDocument'
      @document = document
    else
      @document = DocumentRepository.find document
    end

  end


  def call
    header = AWS.get_string('print-include-header.css', 'print')
    str  = "#{header}\n\n<h1>#{@document.title}</h1>\n\n#{@document.rendered_text}"
    object_name = "#{@document.author_name}-#{@document.id}.html"
    AWS.put_string(str, object_name, 'print')
    @url = "http://psurl.s3.amazonaws.com/print/#{object_name}"
  end

end




