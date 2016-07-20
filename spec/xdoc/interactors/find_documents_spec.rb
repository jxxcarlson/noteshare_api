require 'spec_helper'
require_relative '../../../lib/xdoc/interactors/find_documents'

describe FindDocuments do

  before do

    DocumentRepository.clear
    d = NSDocument.new(title: 'Test', text: 'foo')
    @doc = DocumentRepository.create d

  end

  it 'can produce a document hash' do

    result = FindDocuments.new('').call
    expected = "[{:id=>#{@doc.id}, :title=>'Test', :url=>'http://localhost:2300/documents/#{@doc.id}'}]"


    # puts "DOCUMENTS: #{result.documents}"
    puts "DOCUMENT HASH ARRAY: #{result.document_hash_array}"
    puts "EXPECTED: #{result.document_hash_array.to_s}"

    # assert result.document_hash_array.to_s == expected
    assert result.document_hash_array == [{:id=>@doc.id, :title=>'Test', :url=>'http://localhost:2300/documents/#{@doc.id}'}]


  end

end